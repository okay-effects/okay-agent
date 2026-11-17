package okay.agent.cli

import java.io.OutputStream
import java.nio.file.{Files, Path}
import java.util.concurrent.ConcurrentHashMap
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{AgUi, Ask, HttpBackend, Request}

/** okay-agent openai: THE AGENT AS A MODEL — OpenAI's chat completions, so opencode (and OpenChamber over it, the
 * phone's app too) offers okay-agent in its model list and keeps its conversations as its own sessions. Behind a
 * request the whole program runs: its tools, its gate, its journal — opencode's tools and system prompt are not
 * used. Its steps come back as the reply's text: the model's words, each call a line with how it went.
 *
 * A session of opencode's is a thread of `AgUiServer`'s (one per directory and model): its id the header opencode
 * sends every provider (`x-opencode-session-id`), its directory the one opencode's system prompt names ("Working
 * directory: …"); `x-okay-session` and `x-okay-directory` say them for another client; with neither, the thread
 * the first words'. A call to be asked about ends the
 * reply with the question; the program waits for it, alive, and the session's next message answers it — yes (or
 * y, ok, allow, да) allows, anything else is a no, its words the reason the model reads. A request with no tools
 * (opencode's title, its summary) is the plain model's: forwarded */
final class OpenAiFace(gateway: String, ask: ToolSpec.Kind => Boolean, timeoutSeconds: Int,
    backend: Option[String => okay.llm.Llm.Backend] = None, mcp: Path => Vector[Mcp.Server] = root => Mcp.found(root)):
  private def model(m: String): okay.llm.Llm.Backend = backend.fold(HttpBackend(gateway, m))(_(m))
  private val servers = ConcurrentHashMap[(Path, String), AgUiServer]()
  private val sessions = ConcurrentHashMap[String, String]()

  def serve(req: Request, out: OutputStream): Unit = (req.method, req.path.takeWhile(_ != '?')) match
    case ("GET", "/" | "/v1" | "/v1/") => whole(out, 200, Json.obj("agent" -> Json.Str("okay-agent"),
        "protocol" -> Json.Str("OpenAI chat completions"), "run" -> Json.Str("POST /v1/chat/completions")).render)
    case ("GET", "/v1/models") => whole(out, 200, OpenAiFace.get(gateway.stripSuffix("/") + "/models"))
    case ("POST", "/v1/chat/completions") =>
      val body = Json.fromText(req.body)
      val model = body.field("model").collect { case Json.Str(m) => m }.getOrElse("")
      val stream = !body.field("stream").contains(Json.Bool(false))
      val messages = body.field("messages").map(_.list).getOrElse(Vector.empty)
      val reply = Reply(out, model, stream)
      if body.field("tools").forall(_.list.isEmpty) then plain(model, messages, reply)
      else agent(req, model, messages, reply)
      reply.end()
    case _ => whole(out, 404, """{"error":{"message":"not found"}}""")

  /** no tools: the model alone answers (a title, a summary) */
  private def plain(model: String, messages: Vector[Json], reply: Reply): Unit =
    val g = this.model(model).start(Ask(messages.map(OpenAiFace.plainMessage), maxTokens = 512))
    try
      Iterator.continually(g.next()).takeWhile(_.isDefined).foreach(_ => ())
      reply.say(OpenAiFace.unthought(g.text).trim)
    finally g.close()

  /** the agent's run on the session's thread: a prompt, or the answer to the question it waits on */
  private def agent(req: Request, model: String, messages: Vector[Json], reply: Reply): Unit =
    val texts = messages.filter(m => m.field("role").exists(r => r == Json.Str("user") || r == Json.Str("assistant")))
      .map(m => Json.obj("role" -> m("role"), "content" -> Json.Str(OpenAiFace.text(m("content")))))
    val words = texts.reverse.find(_("role") == Json.Str("user")).map(_("content").string).getOrElse("")
    val dir = req.headers.get("x-okay-directory").filter(_.nonEmpty).orElse(OpenAiFace.directoryOf(messages))
      .map(d => Path.of(d)).filter(Files.isDirectory(_)).map(_.toRealPath())
    dir match
      case None =>
        val first = messages.headOption.map(m => OpenAiFace.text(m("content"))).getOrElse("")
        System.err.println("no directory in: " + OpenAiFace.oneLine(first, 600))
        reply.say("okay-agent: which directory? Neither the header x-okay-directory nor a \"Working directory:\" " +
          "line in the system prompt names one")
      case Some(root) =>
        val session = Vector("x-okay-session", "x-opencode-session-id").flatMap(req.headers.get).find(_.nonEmpty)
        val thread = session.getOrElse(
          sessions.computeIfAbsent(root.toString + "\u0000" + texts.headOption.map(_.render).getOrElse(""),
            _ => s"s-${System.nanoTime()}"))
        val server = servers.computeIfAbsent((root, model), _ =>
          AgUiServer(root, () => this.model(model), ask, mcp = mcp, timeoutSeconds = timeoutSeconds))
        val runId = s"r-${System.nanoTime()}"
        val input = server.waitingFor(thread) match
          case Some(interrupt) =>
            val (yes, why) = OpenAiFace.answer(words)
            reply.say(if yes then "*allowed*\n\n" else s"*not allowed${if why.isEmpty then "" else s": $why"}*\n\n")
            AgUi.RunInput(thread, runId, Vector.empty, Vector.empty, Vector(AgUi.Resume(interrupt, true,
              Json.Obj(Vector("approved" -> Json.Bool(yes)) ++ (if why.isEmpty then Vector.empty
                else Vector("reason" -> Json.Str(why)))))))
          case None => AgUi.RunInput(thread, runId, texts, Vector.empty, Vector.empty)
        server.runTo(input, reply.event)

  private def whole(out: OutputStream, status: Int, body: String): Unit =
    val bytes = body.getBytes("UTF-8")
    out.write((s"HTTP/1.1 $status ${if status < 300 then "OK" else "Error"}\r\nContent-Type: application/json\r\n" +
      s"Content-Length: ${bytes.length}\r\nConnection: close\r\n\r\n").getBytes("UTF-8") ++ bytes)
    out.flush()

  /** the reply: streamed (chunks of chat.completion.chunk, then [DONE]) or whole; the run's events made its text */
  private final class Reply(out: OutputStream, model: String, stream: Boolean):
    private val id = s"chatcmpl-${System.nanoTime()}"
    private val whole = StringBuilder()
    private var opened = false
    private var midLine = false
    private val calls = scala.collection.mutable.Map.empty[String, (String, StringBuilder)]

    private def chunk(delta: Json, finish: Option[String]): Unit =
      val c = Json.obj("id" -> Json.Str(id), "object" -> Json.Str("chat.completion.chunk"),
        "created" -> Json.num(System.currentTimeMillis() / 1000), "model" -> Json.Str(model),
        "choices" -> Json.arr(Json.obj("index" -> Json.num(0), "delta" -> delta,
          "finish_reason" -> finish.fold(Json.Null)(Json.Str(_)))))
      out.write(s"data: ${c.render}\n\n".getBytes("UTF-8"))
      out.flush()

    private def open(): Unit = if !opened then
      opened = true
      if stream then
        out.write(("HTTP/1.1 200 OK\r\nContent-Type: text/event-stream\r\nCache-Control: no-cache\r\n" +
          "Connection: close\r\n\r\n").getBytes("UTF-8"))
        chunk(Json.obj("role" -> Json.Str("assistant"), "content" -> Json.Str("")), None)

    /** words to the text (throws IOException when the client is gone: the run then cancelled) */
    def say(t: String): Unit = if t.nonEmpty then
      open()
      midLine = !t.endsWith("\n")
      if stream then chunk(Json.obj("content" -> Json.Str(t)), None) else whole ++= t

    private def line(t: String): Unit = say((if midLine then "\n\n" else "") + t + "\n\n")

    def event(e: Json): Unit = e.field("type").collect { case Json.Str(t) => t }.getOrElse("") match
      case "TEXT_MESSAGE_CONTENT" => say(e("delta").string)
      case "TEXT_MESSAGE_END" => if midLine then say("\n\n")
      case "TOOL_CALL_START" => calls(e("toolCallId").string) = (e("toolCallName").string, StringBuilder())
      case "TOOL_CALL_ARGS" => calls.get(e("toolCallId").string).foreach(_._2 ++= e("delta").string)
      case "TOOL_CALL_END" => calls.get(e("toolCallId").string).foreach((name, args) =>
          line(s"▸ `$name` ${OpenAiFace.brief(args.toString)}"))
      case "TOOL_CALL_RESULT" =>
        val content = e.field("content").collect { case Json.Str(c) => c }.getOrElse("")
        val lines = content.linesIterator.toVector
        line(if content.startsWith("error: ") || content.startsWith("refused") then
            s"  ✗ ${OpenAiFace.oneLine(lines.headOption.getOrElse(""))}"
          else s"  ✓ ${lines.size} line${if lines.size == 1 then "" else "s"}")
      case "RUN_ERROR" => line(s"⚠ ${e.field("message").map(_.string).getOrElse("")}")
      case "RUN_FINISHED" => e.field("outcome").flatMap(_.field("type")) match
          case Some(Json.Str("interrupt")) =>
            val i = e("outcome")("interrupts").list.head
            line(s"**okay-agent asks:** `${OpenAiFace.oneLine(i("message").string, 300)}`\n\n" +
              "Reply **yes** to allow it, or **no** and why.")
          case Some(Json.Str("cancelled")) => line("*(stopped)*")
          case _ => ()
      case _ => ()

    def end(): Unit =
      open()
      if stream then
        try
          chunk(Json.obj(), Some("stop"))
          out.write("data: [DONE]\n\n".getBytes("UTF-8"))
          out.flush()
        catch case _: java.io.IOException => ()
      else
        val c = Json.obj("id" -> Json.Str(id), "object" -> Json.Str("chat.completion"),
          "created" -> Json.num(System.currentTimeMillis() / 1000), "model" -> Json.Str(model),
          "choices" -> Json.arr(Json.obj("index" -> Json.num(0), "message" -> Json.obj(
            "role" -> Json.Str("assistant"), "content" -> Json.Str(whole.toString)),
            "finish_reason" -> Json.Str("stop"))))
        OpenAiFace.this.whole(out, 200, c.render)

object OpenAiFace:
  /** a message's text: its string, or its text parts */
  def text(c: Json): String = c match
    case Json.Str(t) => t
    case Json.Arr(parts) => parts.flatMap(_.field("text").collect { case Json.Str(t) => t }).mkString("\n")
    case _ => ""

  private def plainMessage(m: Json): Json =
    Json.obj("role" -> m.field("role").getOrElse(Json.Str("user")), "content" -> Json.Str(text(m("content"))))

  /** the directory opencode's system prompt names ("Working directory: …") */
  def directoryOf(messages: Vector[Json]): Option[String] =
    val Dir = """(?m)^\s*Working directory:\s*(\S.*?)\s*$""".r
    messages.filter(_.field("role").contains(Json.Str("system"))).map(m => text(m("content")))
      .flatMap(t => Dir.findFirstMatchIn(t).map(_.group(1))).headOption

  /** a person's answer to a question: yes, or no and why */
  def answer(words: String): (Boolean, String) =
    val t = words.trim
    val first = t.toLowerCase.split("""[\s,.!:;]+""").headOption.getOrElse("")
    if Set("y", "yes", "ok", "okay", "allow", "sure", "go", "да", "ок", "давай", "так", "tak")(first) &&
      t.length <= 40 then (true, "")
    else
      val why = t.replaceFirst("""(?iU)^(no|n|nope|deny|нет|ні|nie)\b[\s,.:;!-]*""", "").trim
      (false, why)

  /** a call's arguments, short: its command, path or pattern */
  def brief(args: String): String =
    val j = scala.util.Try(Json.fromText(args)).toOption
    val key = Vector("command", "path", "pattern", "file_path", "q", "query")
    oneLine(j.flatMap(a => key.flatMap(k => a.field(k).collect { case Json.Str(v) => v }).headOption).getOrElse(args),
      160)

  def oneLine(t: String, max: Int = 200): String =
    val s = t.linesIterator.map(_.trim).filter(_.nonEmpty).mkString(" ⏎ ")
    if s.length <= max then s else s.take(max) + "…"

  def unthought(t: String): String = t.replaceAll("(?s)<think>.*?</think>", "")

  /** a GET's body (the gateway's model list) */
  def get(url: String): String =
    val u = java.net.URI.create(url)
    val s = java.net.Socket(u.getHost, if u.getPort > 0 then u.getPort else 80)
    try
      s.getOutputStream.write(s"GET ${u.getPath} HTTP/1.1\r\nHost: ${u.getHost}\r\nConnection: close\r\n\r\n".getBytes)
      val text = String(s.getInputStream.readAllBytes(), "UTF-8")
      text.substring(text.indexOf("\r\n\r\n") + 4)
    finally s.close()
