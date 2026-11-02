package okay.agent.cli

import java.io.BufferedReader
import java.nio.file.Path
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{Console, Llm}
import okay.scala3.*
import scala.collection.mutable

/** okay-agent acp: THE AGENT SPEAKING ACP (the Agent Client Protocol: JSON-RPC, a line each, over stdio) — a client
 * (okay-remote through okay-guard, Zed) starts it, opens sessions, sends prompts. The same program: its files read and
 * written through the client (`fs/read_text_file`, `fs/write_text_file`), its commands run by the client (the
 * `terminal/...` requests) — so the client's gate weighs each, as it does any ACP agent's; each call shown to it
 * (`tool_call`, `tool_call_update`), the model's words too (`agent_message_chunk`). A session's prompts go on in
 * one conversation (the prefix kept: the model's cache too). One thread: a request of its own answered while it
 * waits, a cancel seen between steps */
final class AcpAgent(in: BufferedReader, out: String => Unit, model: Path => Llm.Backend,
    window: Compact.Window = Compact.Window(32768), budget: Budget = Budget(),
    mcp: Path => Vector[Mcp.Server] = root => Mcp.found(root)):
  private var nextId = 0
  private val queued = mutable.Queue.empty[Json]
  private var fs = false
  private var term = false
  private var cancelled = false
  private final class Session(val id: String, val ws: Workspace, val tools: Vector[ToolSpec], val notes: Vector[String],
      val routes: Map[String, (McpServer, String)], val servers: Vector[McpServer], var ctx: Option[Ctx] = None)
  private val sessions = mutable.Map.empty[String, Session]

  private def send(j: Json): Unit = out(j.render)
  private def reply(id: Json, result: Json): Unit =
    send(Json.obj("jsonrpc" -> Json.Str("2.0"), "id" -> id, "result" -> result))
  private def fail(id: Json, code: Int, message: String): Unit = send(Json.obj("jsonrpc" -> Json.Str("2.0"),
    "id" -> id, "error" -> Json.obj("code" -> Json.num(code), "message" -> Json.Str(message))))
  private def notify(method: String, params: Json): Unit =
    send(Json.obj("jsonrpc" -> Json.Str("2.0"), "method" -> Json.Str(method), "params" -> params))

  /** a message read: a cancel noted at once, any other kept for the loop */
  private def read(): Option[Json] = Option(in.readLine()).map { line =>
    scala.util.Try(Json.fromText(line)).getOrElse(Json.obj())
  }
  private def seen(j: Json): Unit =
    if j.field("method").contains(Json.Str("session/cancel")) then cancelled = true else queued.enqueue(j)
  /** what came in while the agent worked (the model's turn, a command): read without waiting */
  private def drain(): Unit = while in.ready() do read().foreach(seen)

  /** a request of the agent's to the client, its result when it comes (other messages kept meanwhile) */
  private def request(method: String, params: Json): Either[String, Json] =
    nextId += 1
    val id = nextId
    send(Json.obj("jsonrpc" -> Json.Str("2.0"), "id" -> Json.num(id), "method" -> Json.Str(method),
      "params" -> params))
    var answer: Option[Either[String, Json]] = None
    while answer.isEmpty do read() match
      case None => answer = Some(Left("the client went away"))
      case Some(j) if j.field("method").isEmpty && j.field("id").contains(Json.num(id)) =>
        answer = Some(j.field("error").fold(Right(j("result")))(e =>
          Left(e.field("message").collect { case Json.Str(m) => m }.getOrElse(e.render))))
      case Some(j) => seen(j)
    answer.get

  /** the loop: each message answered until the client closes */
  def serve(): Unit =
    var open = true
    while open do
      val next = if queued.nonEmpty then Some(queued.dequeue()) else read()
      next match
        case None => open = false
        case Some(j) => j.field("method").collect { case Json.Str(m) => m }.foreach(m =>
            answer(j.field("id"), m, j("params")))
    sessions.values.foreach(_.servers.foreach(_.close()))

  private def answer(id: Option[Json], method: String, p: Json): Unit = method match
    case "initialize" =>
      val caps = p("clientCapabilities")
      fs = caps("fs")("readTextFile") == Json.Bool(true) && caps("fs")("writeTextFile") == Json.Bool(true)
      term = caps("terminal") == Json.Bool(true)
      id.foreach(reply(_, Json.obj("protocolVersion" -> Json.num(1),
        "agentCapabilities" -> Json.obj("loadSession" -> Json.Bool(false)), "authMethods" -> Json.arr(),
        "agentInfo" -> Json.obj("name" -> Json.Str("okay-agent"), "version" -> Json.Str("0.1.0")))))
    case "session/new" =>
      val root = Path.of(p.field("cwd").collect { case Json.Str(c) => c }.getOrElse(".")).toAbsolutePath
      val ws = Workspace(root)
      val (servers, served, routes) = Mcp.attach(root, mcp(root), Workspace.tools.map(_.name).toSet, _ => ())
      val symdexHere = servers.exists(_.name == "symdex")
      val notes = if symdexHere then Vector(Project.symdexNote) else Vector.empty
      val sid = s"okay-${System.currentTimeMillis()}-${sessions.size}"
      sessions(sid) = Session(sid, ws, Workspace.tools ++ served, notes, routes, servers)
      id.foreach(reply(_, Json.obj("sessionId" -> Json.Str(sid))))
    case "session/prompt" =>
      val sid = p.field("sessionId").collect { case Json.Str(s) => s }.getOrElse("")
      val text = p.field("prompt").map(_.list.flatMap(_.field("text").collect { case Json.Str(t) => t })
        .mkString("\n")).getOrElse("")
      sessions.get(sid) match
        case None => id.foreach(fail(_, -32602, s"no session $sid"))
        case Some(s) =>
          cancelled = false
          val reason = prompt(s, text)
          id.foreach(reply(_, Json.obj("stopReason" -> Json.Str(reason))))
    case "session/cancel" => cancelled = true
    case other => id.foreach(fail(_, -32601, s"okay-agent does not do $other"))

  /** one prompt: the program on the session's conversation; why it stopped, as ACP names it */
  private def prompt(s: Session, text: String): String =
    current = Some(s)
    val ctx = s.ctx.fold(Agent.start(text, s.tools, budget, s.notes))(c => Agent.next(c, text))
    type Row[X] = (Llm + Tools + Console)[X]
    val program = Admit.within[Row, (Outcome, Ctx)](s.tools)(shown[Row, (Outcome, Ctx)](
      Compact.within[Row, (Outcome, Ctx)](window)(Agent.runOn[Row](ctx))))
    try
      val (outcome, end) = run(updates(s.id)(Tools.by(perform(s))(Llm.on(model(s.ws.root))(program))))
      s.ctx = Some(end)
      outcome match
        case Outcome.Done(words) => if words.trim.nonEmpty then said(s.id, words.trim); "end_turn"
        case Outcome.OutOfBudget(_) => "max_turn_requests"
    catch case Acp.Cancelled =>
      // the conversation as it was, the person's words and the stop kept in it
      s.ctx = Some(ctx.copy(messages = ctx.messages :+ Json.obj("role" -> Json.Str("assistant"),
        "content" -> Json.Str("(cancelled)"))))
      "cancelled"

  private def said(sid: String, text: String): Unit =
    update(sid, Json.obj("sessionUpdate" -> Json.Str("agent_message_chunk"),
      "content" -> Json.obj("type" -> Json.Str("text"), "text" -> Json.Str(text))))
  private def update(sid: String, u: Json): Unit =
    notify("session/update", Json.obj("sessionId" -> Json.Str(sid), "update" -> u))

  /** the updates, an effect of the program's (Console: each line one update's JSON), sent as `session/update` */
  private def updates[R[_], Rest[_], A](sid: String)(p: A ! R)(using Split[Console, R, Rest]): A ! Rest =
    handle(p, Handler.tail[Console, Rest, A, A](pure)([X] => (op: Console[X]) => op match
      case Console.Line(text) => update(sid, Json.fromText(text))))

  /** each call shown to the client before it runs and when it ended; the model's words between calls; a cancel
   * honoured before the model's next turn */
  private def shown[R[_], A](p: A ! R)(using In[Llm, R], In[Tools, R], In[Console, R]): A ! R =
    val turns = around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Start(_) =>
        drain()
        if cancelled then throw Acp.Cancelled else proceed
      case Llm.Finish(_) => proceed.flatMap { f =>
        val words = f.reply.content.trim
        if words.isEmpty || f.reply.toolCalls.isEmpty then pure(f)
        else Console.line[R](Json.obj("sessionUpdate" -> Json.Str("agent_message_chunk"),
          "content" -> Json.obj("type" -> Json.Str("text"), "text" -> Json.Str(words + "\n"))).render).as(f)
      }
      case _ => proceed)
    around[Tools, R, A](turns)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) =>
        Console.line[R](Acp.toolCall(call, rawInput(call)).render).andThen(proceed.flatMap { o =>
          Console.line[R](Json.obj("sessionUpdate" -> Json.Str("tool_call_update"),
            "toolCallId" -> Json.Str(call.id), "status" -> Json.Str(if o.error then "failed" else "completed"),
            "content" -> Json.arr(Json.obj("type" -> Json.Str("content"), "content" -> Json.obj(
              "type" -> Json.Str("text"), "text" -> Json.Str(o.text.take(4000)))))).render).as(o)
        }))

  /** a call's input as the client's gate reads it: an absolute `file_path`, a `command` — the same as its fs and
   * terminal requests carry, so a request is matched to the call it came from */
  private var current: Option[Session] = None
  private def rawInput(call: Call): Json =
    def str(k: String) = call.args.field(k).collect { case Json.Str(v) => v }
    val path = current.flatMap(s => str("path").flatMap(p => scala.util.Try(s.ws.inside(p).toString).toOption))
    call.name match
      case "read" | "write" | "edit" => Json.Obj(call.args.record.filterNot(_._1 == "path") ++
          path.map("file_path" -> Json.Str(_)).toVector)
      case "git_commit" => Json.obj("command" -> Json.Str(Acp.commitLine(str("message").getOrElse(""))))
      case _ => call.args

  /** a call performed: through the client where it can (files, commands), here otherwise */
  private def perform(s: Session)(call: Call): Obs =
    def str(k: String) = call.args.field(k).collect { case Json.Str(v) => v }
    val o = try
      routes(s, call).getOrElse(call.name match
        case "read" if fs => readFile(s, s.ws.inside(str("path").getOrElse(""))).fold(Obs(_, error = true), Obs(_))
        case "write" if fs =>
          val f = s.ws.inside(str("path").getOrElse(""))
          val content = str("content").getOrElse("")
          writeFile(s, f, content).fold(Obs(_, error = true), _ =>
            Obs(s"wrote ${s.ws.root.relativize(f)} (${content.linesIterator.size} lines)"))
        case "edit" if fs => edit(s, s.ws.inside(str("path").getOrElse("")), str("old").getOrElse(""),
            str("new").getOrElse(""))
        case "bash" if term => command(s, str("command").getOrElse(""))
        case "git_commit" if term => command(s, Acp.commitLine(str("message").getOrElse("")))
        case _ => s.ws.perform(call))
    catch case e: Exception => Obs(Option(e.getMessage).getOrElse(e.toString), error = true)
    if cancelled then throw Acp.Cancelled
    Main.nudged(call, o, s.servers.exists(_.name == "symdex"))

  /** a call of an MCP server's: one that may change something asked about first (`session/request_permission`) —
   * the client's gate sees no request of its own for it */
  private def routes(s: Session, call: Call): Option[Obs] =
    s.routes.get(call.name).map { (server, name) =>
      val reads = s.tools.find(_.name == call.name).exists(_.kind == ToolSpec.Kind.Read)
      if reads || allowed(s, call) then server.call(name, call.args)
      else Obs(s"not allowed: ${call.name}", error = true)
    }
      .orElse(Option.when(call.name == Symdex.spec.name)(Symdex.setup(s.ws)))

  private def allowed(s: Session, call: Call): Boolean =
    def option(id: String, kind: String) = Json.obj("optionId" -> Json.Str(id), "name" -> Json.Str(id),
      "kind" -> Json.Str(kind))
    request("session/request_permission", Json.obj(sid(s), "toolCall" -> Json.obj("toolCallId" -> Json.Str(call.id),
      "title" -> Json.Str(call.name), "kind" -> Json.Str("other"), "rawInput" -> call.args),
      "options" -> Json.arr(option("allow", "allow_once"), option("reject", "reject_once")))).toOption
      .flatMap(_.field("outcome")).flatMap(_.field("optionId")).contains(Json.Str("allow"))

  private def sid(s: Session) = "sessionId" -> Json.Str(s.id)
  private def readFile(s: Session, f: Path): Either[String, String] =
    request("fs/read_text_file", Json.obj(sid(s), "path" -> Json.Str(f.toString)))
      .map(_.field("content").collect { case Json.Str(t) => t }.getOrElse(""))
  private def writeFile(s: Session, f: Path, content: String): Either[String, Unit] =
    request("fs/write_text_file", Json.obj(sid(s), "path" -> Json.Str(f.toString), "content" -> Json.Str(content)))
      .map(_ => ())

  private def edit(s: Session, f: Path, old: String, neu: String): Obs =
    val name = s.ws.root.relativize(f)
    readFile(s, f) match
      case Left(why) => Obs(why, error = true)
      case Right(text) =>
        val at = text.indexOf(old)
        if old.isEmpty then Obs("'old' is empty", error = true)
        else if at < 0 then Obs(s"'old' is not in $name: read it again, and copy the fragment exactly", error = true)
        else if text.indexOf(old, at + 1) >= 0 then Obs(s"'old' is in $name more than once: take more of it",
          error = true)
        else writeFile(s, f, text.substring(0, at) + neu + text.substring(at + old.length))
          .fold(Obs(_, error = true), _ => Obs(s"edited $name"))

  /** a command the client runs: a shell's line, as okay-guard's terminals take it (its policy reads the line) */
  private def command(s: Session, line: String): Obs =
    request("terminal/create", Json.obj(sid(s), "command" -> Json.Str(line), "args" -> Json.arr(),
      "cwd" -> Json.Str(s.ws.root.toString), "outputByteLimit" -> Json.num(20000))) match
      case Left(why) => Obs(why, error = true)
      case Right(r) =>
        val t = "terminalId" -> r("terminalId")
        val code = request("terminal/wait_for_exit", Json.obj(sid(s), t)).toOption
          .flatMap(_.field("exitCode")).collect { case Json.Num(n) => n.toInt }.getOrElse(1)
        val text = request("terminal/output", Json.obj(sid(s), t)).toOption
          .flatMap(_.field("output")).collect { case Json.Str(o) => o }.getOrElse("")
        request("terminal/release", Json.obj(sid(s), t))
        Obs(text + (if code == 0 then "" else s"\n(exit $code)"), error = code != 0)

object Acp:
  case object Cancelled extends Exception("cancelled")

  def commitLine(message: String): String =
    s"git add -A && git commit -q -m ${Workspace.quote(message)} && git log --oneline -1"

  /** a call as ACP shows it: its kind (what it does to the world), a title by the names policies use */
  def toolCall(call: Call, input: Json): Json =
    val (kind, title) = call.name match
      case "read" => ("read", "Read")
      case "write" => ("edit", "Write")
      case "edit" => ("edit", "Edit")
      case "bash" | "git_commit" => ("execute", "Bash")
      case "glob" => ("search", "Glob")
      case "grep" => ("search", "Grep")
      case other => ("other", other)
    Json.Obj(Vector("sessionUpdate" -> Json.Str("tool_call"), "toolCallId" -> Json.Str(call.id),
      "title" -> Json.Str(title), "kind" -> Json.Str(kind), "status" -> Json.Str("pending"), "rawInput" -> input) ++
      input.field("file_path").map(p => "locations" -> Json.arr(Json.obj("path" -> p))).toVector)
