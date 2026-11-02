package okay.agent.cli

import java.nio.file.Path
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{Console, HttpBackend, Llm}
import okay.scala3.*
import scala.jdk.CollectionConverters.*

/** okay-agent "<task>": the agent in this directory — its tools the workspace's, the terminal its person, the model
 * behind a server speaking OpenAI's API (okay-mlx's gateway by default). Writes, commands and commits asked about
 * first, unless --yes */
@main def okayAgent(args: String*): Unit =
  def flag(n: String) = args.indexOf(n) match
    case -1 => None
    case i => args.lift(i + 1)
  if args.headOption.contains("acp") then Main.acp(args.tail)
  if args.headOption.contains("serve") then Main.serve(args.tail)
  val valued = Set("--url", "--model", "--turns", "--tokens", "--dir", "--window", "--replay", "--forecast",
    "--timeout")
  val task = args.zipWithIndex.filterNot((a, i) => a.startsWith("--") || (i > 0 && valued(args(i - 1))))
    .map(_._1).mkString(" ")
  val replay = flag("--replay")
  if task.isEmpty && replay.isEmpty then
    System.err.println("""usage: okay-agent [--url http://127.0.0.1:8090/v1] [--model M] [--turns N] [--tokens N]
                         |                  [--window N] [--dir D] [--yes] [--forecast N] [--timeout S] "<task>"
                         |       okay-agent --replay <journal.jsonl>   (the run again from its journal, no model)
                         |       okay-agent acp [--url U] [--model M] [--forecast N]   (an ACP agent over stdio)
                         |       okay-agent serve [--port 8091] [--dir D] [--yes] [--forecast N] [--url U] [--model M]
                         |""".stripMargin)
    sys.exit(2)
  replay.foreach { file =>
    val entries = java.nio.file.Files.readAllLines(Path.of(file)).asScala.toVector.filter(_.nonEmpty).map(Json.fromText)
    val outcome = Main.replayed(entries, println)
    println(s"\nreplayed: $outcome")
    sys.exit(0)
  }
  val url = flag("--url").orElse(sys.env.get("OKAY_AGENT_URL")).getOrElse("http://127.0.0.1:8090/v1")
  val model = flag("--model").orElse(sys.env.get("OKAY_AGENT_MODEL")).getOrElse(Main.firstModel(url))
  val window = Compact.Window(flag("--window").map(_.toInt).getOrElse(32768))
  val budget = Budget(flag("--turns").map(_.toInt).getOrElse(40), flag("--tokens").map(_.toInt).getOrElse(32000))
  val ask: ToolSpec.Kind => Boolean = if args.contains("--yes") then _ => false else _ != ToolSpec.Kind.Read
  // --forecast N: before a call that is not a read, what comes after it forecast (N turns, the model the same, the
  // calls imagined, reads real); asked only when it or what comes is risky
  val horizon = if args.contains("--yes") then 0 else flag("--forecast").map(_.toInt).getOrElse(0)
  // a command's time at most (a build's test run takes minutes)
  val timeout = flag("--timeout").map(_.toInt).getOrElse(300)
  val workspace = Workspace(flag("--dir").map(Path.of(_)).getOrElse(Path.of("")).toAbsolutePath, timeout)
  // the project's MCP servers, with no setting: its .mcp.json, and symdex where there is an index for it
  val (servers, served, routes) = Mcp.attach(workspace.root, Mcp.found(workspace.root),
    Workspace.tools.map(_.name).toSet, m => System.err.println(m))
  servers.foreach(s => System.err.println(s"mcp: ${s.name} — ${s.tools.size} tools"))
  val sbtProject = java.nio.file.Files.exists(workspace.root.resolve("build.sbt"))
  val symdexHere = servers.exists(_.name == "symdex")
  if sbtProject && !symdexHere && !Mcp.indexed(workspace.root) then
    System.err.println("symdex: no index here — sbt 'set every semanticdbEnabled := true' Test/compile")
  val tools = Workspace.tools ++ served ++ (if sbtProject && !symdexHere then Vector(Symdex.spec) else Vector.empty)
  // what this run's tools are for: symdex's exact answers before grep
  val notes = if symdexHere then Vector("For where something is defined or used, who calls it, what implements it, " +
    "use definition, references (callers=true), implementations, outline: exact, from the compiler; grep is for text.")
    else Vector.empty
  def perform(call: Call): Obs = routes.get(call.name) match
    case Some((server, name)) => server.call(name, call.args)
    case None =>
      val o = if call.name == Symdex.spec.name then Symdex.setup(workspace) else workspace.perform(call)
      Main.nudged(call, o, symdexHere)
  System.err.println(s"okay-agent · $model · ${workspace.root}")

  type Row[X] = (Llm + Tools + Human + Console + Journal)[X]
  val t0 = System.nanoTime()
  // the journal: ~/.okay-agent/journals, not the project (a commit would take it)
  val journal = Main.journalFile(workspace.root)
  System.err.println(s"journal: $journal")
  val out = java.io.PrintWriter(java.nio.file.Files.newBufferedWriter(journal))
  out.println(Json.obj("k" -> Json.Str("start"), "task" -> Json.Str(task), "model" -> Json.Str(model),
    "turns" -> Json.num(budget.turns), "tokens" -> Json.num(budget.tokens),
    "tools" -> Json.Arr(tools.map(Main.specJson)), "notes" -> Json.Arr(notes.map(Json.Str(_))),
    "forecast" -> Json.num(horizon)).render)
  val inner = Admit.within[Row, Outcome](tools)(Main.shown[Row, Outcome](Compact.within[Row, Outcome](window)(
    Agent.run[Row](Agent.start(task, tools, budget, notes)))))
  def imagine(c: Call): Obs =
    if tools.find(_.name == c.name).exists(_.kind == ToolSpec.Kind.Read) then perform(c) else Main.imagined(c)
  val program = Journal.recording[Row, Outcome](
    if horizon > 0 then Forecast.gate[Row, Outcome](tools, horizon, imagine)(inner)
    else Gate.asking[Row, Outcome](tools, ask)(inner))
  val outcome = try run(Journal.to(e => { out.println(e.render); out.flush() })(Console.stdout(
    Human.by(Main.terminal)(Tools.by(perform)(Llm.on(HttpBackend(url, model))(program))))))
    finally
      out.close()
      servers.foreach(_.close())
  val seconds = (System.nanoTime() - t0) / 1e9
  outcome match
    case Outcome.Done(summary) => println(s"\n$summary"); System.err.println(f"done in $seconds%.1f s")
    case Outcome.OutOfBudget(what) => System.err.println(f"out of budget ($what) after $seconds%.1f s"); sys.exit(1)

object Main:
  type Replayed[X] = (Llm + Tools + Human + Console)[X]
  /** a run again from its journal, no model, no world: from its start's conversation (a session's later prompt) or
   * its task; its forecasts' turns read in place; the lines shown given to `line` */
  def replayed(entries: Vector[Json], line: String => Unit): Outcome =
    val start = entries.find(_("k").string == "start").getOrElse(sys.error("no start entry"))
    val offered = start.field("tools").map(_.list.map(Main.specOf)).getOrElse(Workspace.tools)
    val notes = start.field("notes").map(_.list.map(_.string)).getOrElse(Vector.empty)
    val budget = Budget(start("turns").int, start("tokens").int)
    val ctx = start.field("messages").map(ms => Ctx(ms.list, offered, budget))
      .getOrElse(Agent.start(start("task").string, offered, budget, notes))
    // a run with forecasts: their turns in the journal too, read in the same places (nobody asked: the answers are
    // the acts written)
    val horizon = start.field("forecast").map(_.int).getOrElse(0)
    val core = Main.shown[Replayed, Outcome](Admit.within[Replayed, Outcome](offered)(Agent.run[Replayed](ctx)))
    val program = if horizon == 0 then core
      else Forecast.gate[Replayed, Outcome](offered, horizon, Main.imagined, Some((_, _, _) => false))(core)
    run(AgUiServer.lines(line)(Human.by(_ => "n")(Replay.from(entries)(program))))

  /** a call the forecast does not make: taken as done */
  def imagined(c: Call): Obs = Obs(s"(forecast: ${c.name} not performed; take it as done)")

  /** okay-agent serve: the agent as an AG-UI server for one project — writes, commands and commits asked about
   * (an interrupt each) unless --yes */
  def serve(args: Seq[String]): Nothing =
    def flag(n: String) = args.indexOf(n) match
      case -1 => None
      case i => args.lift(i + 1)
    val url = flag("--url").orElse(sys.env.get("OKAY_AGENT_URL")).getOrElse("http://127.0.0.1:8090/v1")
    val model = flag("--model").orElse(sys.env.get("OKAY_AGENT_MODEL")).getOrElse(firstModel(url))
    val root = flag("--dir").map(Path.of(_)).getOrElse(Path.of("")).toAbsolutePath
    val ask: ToolSpec.Kind => Boolean = if args.contains("--yes") then _ => false else _ != ToolSpec.Kind.Read
    val server = AgUiServer(root, () => HttpBackend(url, model), ask,
      Compact.Window(flag("--window").map(_.toInt).getOrElse(32768)),
      forecast = if args.contains("--yes") then 0 else flag("--forecast").map(_.toInt).getOrElse(0),
      timeoutSeconds = flag("--timeout").map(_.toInt).getOrElse(300))
    System.err.println(s"okay-agent · $model · $root · AG-UI: POST /agent")
    okay.llm.Server.run(flag("--port").map(_.toInt).getOrElse(8091))(server.serve)
    sys.exit(0)

  /** okay-agent acp: the agent for an ACP client, over stdin and stdout (nothing else written there) */
  def acp(args: Seq[String]): Nothing =
    def flag(n: String) = args.indexOf(n) match
      case -1 => None
      case i => args.lift(i + 1)
    val url = flag("--url").orElse(sys.env.get("OKAY_AGENT_URL")).getOrElse("http://127.0.0.1:8090/v1")
    val model = flag("--model").orElse(sys.env.get("OKAY_AGENT_MODEL")).getOrElse(firstModel(url))
    val window = Compact.Window(flag("--window").map(_.toInt).getOrElse(32768))
    val stdout = System.out
    // stdout is the protocol's: anything printed elsewhere goes to stderr
    System.setOut(System.err)
    val in = java.io.BufferedReader(java.io.InputStreamReader(System.in, "UTF-8"))
    AcpAgent(in, line => { stdout.print(line + "\n"); stdout.flush() }, _ => HttpBackend(url, model), window,
      timeoutSeconds = flag("--timeout").map(_.toInt).getOrElse(300),
      forecast = flag("--forecast").map(_.toInt).getOrElse(0)).serve()
    sys.exit(0)

  /** a grep for a symbol that found nothing, with symdex here: the model told where the uses are found — text misses
   * `p.price` for `Pricing.price` (seen: a local model grepped, found nothing, answered wrong) */
  def nudged(call: Call, o: Obs, symdex: Boolean): Obs =
    val pattern = call.args.field("pattern").collect { case Json.Str(p) => p }.getOrElse("")
    val symbolLike = pattern.replace("\\", "").matches("[A-Za-z_][A-Za-z0-9_]*([.#][A-Za-z_][A-Za-z0-9_]*)*")
    if call.name == "grep" && symdex && symbolLike && o.text == "no match" then
      o.copy(text = s"no match as text. A symbol's uses through a value (p.price for Pricing.price) are not in the " +
        s"text: references query=${pattern.replace("\\", "")} callers=true finds them")
    else o

  /** a tool offered, as the journal keeps it (its kind too) */
  def specJson(t: ToolSpec): Json = Json.obj("name" -> Json.Str(t.name), "description" -> Json.Str(t.description),
    "parameters" -> t.parameters, "kind" -> Json.Str(t.kind.toString))
  def specOf(j: Json): ToolSpec = ToolSpec(j("name").string, j("description").string, j("parameters"),
    ToolSpec.Kind.valueOf(j("kind").string))

  /** a run's journal: ~/.okay-agent/journals/<project>-<millis>.jsonl */
  def journalFile(project: Path): Path =
    val dir = Path.of(sys.props("user.home"), ".okay-agent", "journals")
    java.nio.file.Files.createDirectories(dir)
    // milliseconds since 1970 (Scala Native has no java.time)
    dir.resolve(s"${project.getFileName}-${System.currentTimeMillis()}.jsonl")

  /** each turn and each call shown as it goes: the model's words, its timings, the call and what it gave */
  def shown[R[_], A](p: A ! R)(using In[Llm, R], In[Tools, R], In[Console, R]): A ! R =
    val turns = around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Finish(_) => proceed.flatMap { f =>
        val t = f.timing
        val words = if f.reply.content.trim.isEmpty || f.reply.toolCalls.isEmpty then unit[R]
          else Console.line[R](s"· ${f.reply.content.trim}")
        val cached = if t.cachedTokens > 0 then s" (${t.cachedTokens} cached)" else ""
        words.andThen(Console.line[R](f"  [${t.promptTokens} in$cached, ${t.prefillNanos / 1e9}%.1f s; " +
          s"${t.tokens} out]")).as(f)
      }
      case _ => proceed)
    around[Tools, R, A](turns)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) => proceed.flatMap { o =>
        val head = o.text.linesIterator.take(3).mkString(" ⏎ ").take(160)
        Console.line[R](s"${if o.error then "✗" else "→"} ${call.name} ${call.args.render.take(120)}  $head").as(o)
      })

  /** the person at the terminal */
  def terminal(question: String): String =
    print(question)
    Option(scala.io.StdIn.readLine()).getOrElse("")

  /** the first model a server lists (GET /models) */
  def firstModel(url: String): String =
    val u = java.net.URI.create(url.stripSuffix("/") + "/models")
    val s = java.net.Socket(u.getHost, if u.getPort > 0 then u.getPort else 80)
    try
      s.getOutputStream.write(s"GET ${u.getPath} HTTP/1.1\r\nHost: ${u.getHost}\r\nConnection: close\r\n\r\n".getBytes)
      val text = String(s.getInputStream.readAllBytes(), "UTF-8")
      Json.fromText(text.substring(text.indexOf("\r\n\r\n") + 4))("data").list.head("id").string
    finally s.close()
