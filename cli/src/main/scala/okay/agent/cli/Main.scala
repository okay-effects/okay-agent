package okay.agent.cli

import java.nio.file.Path
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{Console, HttpBackend, Llm}
import okay.scala3.*

/** okay-agent "<task>": the agent in this directory — its tools the workspace's, the terminal its person, the model
 * behind a server speaking OpenAI's API (okay-mlx's gateway by default). Writes, commands and commits asked about
 * first, unless --yes */
@main def okayAgent(args: String*): Unit =
  def flag(n: String) = args.indexOf(n) match
    case -1 => None
    case i => args.lift(i + 1)
  val valued = Set("--url", "--model", "--turns", "--tokens", "--dir")
  val task = args.zipWithIndex.filterNot((a, i) => a.startsWith("--") || (i > 0 && valued(args(i - 1))))
    .map(_._1).mkString(" ")
  if task.isEmpty then
    System.err.println("""usage: okay-agent [--url http://127.0.0.1:8090/v1] [--model M] [--turns N] [--tokens N]
                         |                  [--dir D] [--yes] "<task>"""".stripMargin)
    sys.exit(2)
  val url = flag("--url").orElse(sys.env.get("OKAY_AGENT_URL")).getOrElse("http://127.0.0.1:8090/v1")
  val model = flag("--model").orElse(sys.env.get("OKAY_AGENT_MODEL")).getOrElse(Main.firstModel(url))
  val budget = Budget(flag("--turns").map(_.toInt).getOrElse(40), flag("--tokens").map(_.toInt).getOrElse(32000))
  val ask: ToolSpec.Kind => Boolean = if args.contains("--yes") then _ => false else _ != ToolSpec.Kind.Read
  val workspace = Workspace(flag("--dir").map(Path.of(_)).getOrElse(Path.of("")).toAbsolutePath)
  val tools = Workspace.tools
  System.err.println(s"okay-agent · $model · ${workspace.root}")

  type Row[X] = (Llm + Tools + Human + Console)[X]
  val t0 = System.nanoTime()
  val program = Gate.asking[Row, Outcome](tools, ask)(Admit.within[Row, Outcome](tools)(
    Main.shown[Row, Outcome](Agent.run[Row](Agent.start(task, tools, budget)))))
  val outcome = run(Console.stdout(Human.by(Main.terminal)(Tools.by(workspace.perform)(
    Llm.on(HttpBackend(url, model))(program)))))
  val seconds = (System.nanoTime() - t0) / 1e9
  outcome match
    case Outcome.Done(summary) => println(s"\n$summary"); System.err.println(f"done in $seconds%.1f s")
    case Outcome.OutOfBudget(what) => System.err.println(f"out of budget ($what) after $seconds%.1f s"); sys.exit(1)

object Main:
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
