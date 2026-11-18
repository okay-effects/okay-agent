package okay.agent.cli

import java.nio.file.Path
import java.util.concurrent.{CountDownLatch, LinkedBlockingQueue, TimeUnit}
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{Console, Llm}
import okay.scala3.*

/** THE CLIENT'S TOOLS (okay-agent openai, the default): the program runs on the tools the request offers, and the
 * CLIENT performs each call — opencode, with its own tool cards and its own permission prompts (OpenChamber Mobile's
 * Allow / Deny). A call the program makes ends the reply as OpenAI's `tool_calls`; the program waits for it ALIVE
 * (no replay) and the next request's `tool` message is its observation, the program going on, its words on that
 * request's reply. Admit, Stuck, Wander, Compact, the budget and the journal are the program's as anywhere; its own
 * gate is off (the client's permissions gate). A new user message while it waits: the waiting program cancelled, the
 * conversation going on from it ([[Agent.next]]). Nothing for 30 minutes: cancelled */
final class ClientTools(model: String => Llm.Backend, window: Compact.Window = Compact.Window(32768),
    budget: Budget = Budget(), stuck: Int = 3, waitFor: Long = 30 * 60 * 1000L, journals: Boolean = true):
  import ClientTools.*

  /** what one request gets back: the words as they come, a call to perform, the end */
  trait Out:
    def words(t: String): Unit
    def call(id: String, name: String, args: String): Unit
    def gone: Boolean

  private final class Thread_(val key: String, val modelName: String, val root: Path):
    var ctx: Option[Ctx] = None
    var worker: Option[Thread] = None
    @volatile var out: Out = null
    /** the request's end: the program paused on a call (true) or ended (false) */
    @volatile var paused: CountDownLatch = CountDownLatch(1)
    @volatile var pausedOnCall = false
    /** the call the client performs now, under the id it was given */
    @volatile var waiting: Option[String] = None
    val answers = LinkedBlockingQueue[Option[Obs]]()
    var calls = 0
  private val threads = scala.collection.mutable.Map.empty[String, Thread_]

  /** a request of the session's: its messages (OpenAI's), the tools offered; back when the program pauses on a call
   * (true: finish with `tool_calls`) or ends (false) */
  def request(session: String, modelName: String, root: Path, messages: Vector[Json], offered: Vector[ToolSpec],
      out: Out): Boolean =
    val t = synchronized(threads.getOrElseUpdate(session + "\u0000" + modelName,
      Thread_(session, modelName, root)))
    t.synchronized {
      val last = messages.lastOption
      val lastRole = last.flatMap(_.field("role")).collect { case Json.Str(r) => r }.getOrElse("")
      // the request's own end, set once no earlier program can reach it
      def begin(): Unit = { t.out = out; t.paused = CountDownLatch(1); t.pausedOnCall = false }
      (t.waiting, lastRole) match
        case (Some(id), "tool") =>
          // the client's observation: the program goes on with it, its words on this request
          val result = messages.reverse.takeWhile(_("role") == Json.Str("tool"))
            .find(_.field("tool_call_id").contains(Json.Str(id))).orElse(last)
          val text = OpenAiFace.text(result.get("content"))
          begin()
          t.waiting = None
          t.answers.put(Some(Obs(text, error = failed(text))))
        case (Some(_), _) =>
          // a new message instead: the waiting program cancelled, the conversation going on from it
          t.waiting = None
          t.answers.put(None)
          t.worker.foreach(_.join(10000))
          begin()
          start(t, words(messages), offered, messages)
        case (None, "tool") =>
          begin()
          out.words("(okay-agent no longer waits for this call — say what to do next)")
          t.paused.countDown()
        case (None, _) =>
          t.worker.foreach(_.join(10000))
          begin()
          start(t, words(messages), offered, messages)
    }
    t.paused.await()
    t.pausedOnCall

  private def start(t: Thread_, text: String, tools: Vector[ToolSpec], messages: Vector[Json]): Unit =
    val notes = Vector(s"The project directory is ${t.root}; the tools take absolute paths under it.")
    val ctx = t.ctx match
      case Some(c) => Agent.next(c.copy(tools = tools), text)
      case None =>
        // a conversation the client began before: its texts kept between the system prompt and the last words
        val c = Agent.start(text, tools, budget, notes)
        c.copy(messages = c.messages.head +: (history(messages).dropRight(1) :+ c.messages.last))
    val w = Thread(() => program(t, ctx), s"client-${t.key}")
    w.setDaemon(true)
    t.worker = Some(w)
    w.start()

  /** the program on a thread's conversation: its words to the request on, each call to the client */
  private def program(t: Thread_, ctx: Ctx): Unit =
    type Row[X] = (Llm + Tools + Human + Console + Journal)[X]
    var lastStreamed = false
    def check(): Unit = if t.out.gone then throw Cancelled
    // the client performs it: this request ends with the call; the next one's tool message is its observation
    def perform(c: Call): Obs =
      check()
      t.calls += 1
      val id = s"call_${t.calls}_${java.lang.Long.toString(System.nanoTime(), 36)}"
      t.waiting = Some(id)
      t.out.call(id, c.name, c.args.render)
      t.pausedOnCall = true
      t.paused.countDown()
      Option(t.answers.poll(waitFor, TimeUnit.MILLISECONDS)).flatten match
        case Some(o) => o
        case None => throw Cancelled
    def words(p: (Outcome, Ctx) ! Row) = Words.streamed[Row, (Outcome, Ctx)](w => Console.line[Row](w),
      any => { lastStreamed = any; if any then Console.line[Row]("\n\n") else unit[Row] })(p)
    val inner = Admit.within[Row, (Outcome, Ctx)](ctx.tools)(Stuck.asking[Row, (Outcome, Ctx)](ctx.tools, stuck)(
      Wander.nudging[Row, (Outcome, Ctx)](ctx.tools)(words(Compact.within[Row, (Outcome, Ctx)](window)(
        Journal.recording[Row, (Outcome, Ctx)](Agent.runOn[Row](ctx)))))))
    val file = if journals then Some(Main.journalFile(t.root)) else None
    val jout = file.map(f => java.io.PrintWriter(java.nio.file.Files.newBufferedWriter(f)))
    jout.foreach(_.println(Json.obj("k" -> Json.Str("start"), "turns" -> Json.num(ctx.budget.turns),
      "tokens" -> Json.num(ctx.budget.tokens), "tools" -> Json.Arr(ctx.tools.map(Main.specJson)),
      "messages" -> Json.Arr(ctx.messages)).render))
    try
      // stuck: nobody to ask but the client's own permission prompts — go on
      val (outcome, end) = run(Journal.to(e => jout.foreach { o => o.println(e.render); o.flush() })(
        AgUiServer.lines(l => { check(); t.out.words(l) })(Human.by(_ => "y")(
          Tools.by(perform)(Llm.on(model(t.modelName))(inner))))))
      t.ctx = Some(end)
      outcome match
        case Outcome.Done(w) => if !lastStreamed then t.out.words(w.trim)
        case Outcome.OutOfBudget(what) => t.out.words(s"\n\n(out of budget: $what)")
    catch
      case Cancelled =>
        t.ctx = Some(ctx.copy(messages = ctx.messages :+ Json.obj("role" -> Json.Str("assistant"),
          "content" -> Json.Str("(cancelled)"))))
      case e: Throwable =>
        t.ctx = Some(ctx)
        scala.util.Try(t.out.words(s"\n\n⚠ ${Option(e.getMessage).getOrElse(e.toString)}"))
    finally
      jout.foreach(_.close())
      t.waiting = None
      t.pausedOnCall = false
      t.paused.countDown()

object ClientTools:
  case object Cancelled extends Exception("cancelled")

  /** the person's last words */
  def words(messages: Vector[Json]): String =
    messages.reverse.find(_.field("role").contains(Json.Str("user"))).map(m => OpenAiFace.text(m("content")))
      .getOrElse("")

  /** the user and assistant texts before the last message: a conversation the client began elsewhere */
  def history(messages: Vector[Json]): Vector[Json] =
    messages.filter(m => m.field("role").exists(r => r == Json.Str("user") || r == Json.Str("assistant")))
      .map(m => Json.obj("role" -> m("role"), "content" -> Json.Str(OpenAiFace.text(m("content")))))
      .filter(_("content").string.nonEmpty)

  /** a client's tool result that reads as a failure */
  def failed(text: String): Boolean =
    val t = text.trim.toLowerCase
    t.startsWith("error") || t.contains("rejected permission") || t.contains("user rejected") ||
      t.startsWith("permission denied")

  /** the tools a request offers, as the program's: the name and schema as given, the description its first sentence
   * (a client's are long: the prompt stays short), the kind by the name */
  def specs(tools: Vector[Json]): Vector[ToolSpec] = tools.flatMap(_.field("function")).flatMap { f =>
    f.field("name").collect { case Json.Str(n) => n }.map { name =>
      val d = f.field("description").collect { case Json.Str(d) => d }.getOrElse("")
      ToolSpec(name, brief(d), f.field("parameters").getOrElse(Json.obj("type" -> Json.Str("object"))), kind(name))
    }
  }

  def brief(d: String): String =
    val line = d.trim.linesIterator.map(_.trim).find(_.nonEmpty).getOrElse("")
    val end = line.indexOf(". ")
    val first = if end > 0 then line.take(end + 1) else line
    if first.length <= 200 then first else first.take(199) + "…"

  def kind(name: String): ToolSpec.Kind =
    val n = name.toLowerCase
    val reads = Vector("read", "glob", "grep", "list", "ls", "find", "search", "fetch", "view", "todoread", "lsp",
      "symdex", "references", "definition", "outline", "skill")
    val writes = Vector("write", "edit", "patch", "multiedit", "apply", "todowrite")
    if writes.exists(n.contains) then ToolSpec.Kind.Write
    else if reads.exists(n.contains) then ToolSpec.Kind.Read
    else ToolSpec.Kind.Exec
