package okay.agent.cli

import java.io.OutputStream
import java.nio.file.Path
import java.util.concurrent.{CountDownLatch, LinkedBlockingQueue, TimeUnit}
import okay.agent.*
import okay.effects.json.Json
import okay.llm.{AgUi, Console, Llm, Request}
import okay.scala3.*
import scala.collection.mutable

/** okay-agent serve: THE AGENT AS AN AG-UI SERVER — `POST /agent` (RunAgentInput) answered with the run's events as
 * server-sent events, any AG-UI client its front end. A thread (AG-UI's) is one conversation, kept here (the prefix
 * kept: the model's cache too); its next run goes on from the last user message. A call to be asked about ends the
 * run with an interrupt (an approval); the program waits for it, alive — no replay — and the next run's `resume`
 * answers it, the program going on, its events on the new run's stream. A client gone mid-run cancels it */
final class AgUiServer(root: Path, model: () => Llm.Backend, ask: ToolSpec.Kind => Boolean,
    window: Compact.Window = Compact.Window(32768), budget: Budget = Budget(), forecast: Int = 0,
    mcp: Path => Vector[Mcp.Server] = root => Mcp.found(root), waitFor: Long = 30 * 60 * 1000L):
  lazy val project: Project = Project(root, mcp)

  /** where a run's events go: a response's stream, until the run ends or pauses */
  private final class Sink(out: OutputStream, val runId: String):
    val done = CountDownLatch(1)
    @volatile var gone = false
    def emit(e: Json): Unit = if !gone then
      try { out.write(AgUi.sse(e).getBytes("UTF-8")); out.flush() }
      catch case _: java.io.IOException => gone = true
    def finish(): Unit = done.countDown()

  private final class Thread_(val id: String):
    var ctx: Option[Ctx] = None
    var running = false
    @volatile var sink: Sink = null
    /** the interrupt the program waits on, and where its answer comes */
    @volatile var waiting: Option[String] = None
    val answers = LinkedBlockingQueue[AgUi.Resume]()
    var messages = 0
  private val threads = mutable.Map.empty[String, Thread_]

  def serve(req: Request, out: OutputStream): Unit = (req.method, req.path.takeWhile(_ != '?')) match
    case ("OPTIONS", _) => head(out, 204, "text/plain", "Content-Length: 0\r\n")
    case ("GET", "/") => whole(out, 200, Json.obj("agent" -> Json.Str("okay-agent"), "protocol" -> Json.Str("AG-UI"),
        "run" -> Json.Str("POST /agent"), "project" -> Json.Str(root.toString)).render)
    case ("POST", "/" | "/agent") =>
      val in = AgUi.RunInput.parse(Json.fromText(req.body))
      head(out, 200, "text/event-stream", "Cache-Control: no-cache\r\n")
      val sink = Sink(out, in.runId)
      run(in, sink)
      sink.done.await()
    case _ => whole(out, 404, """{"error":"not found"}""")

  private def head(out: OutputStream, status: Int, contentType: String, extra: String): Unit =
    out.write((s"HTTP/1.1 $status ${if status < 300 then "OK" else "Error"}\r\nContent-Type: $contentType\r\n" +
      "Access-Control-Allow-Origin: *\r\nAccess-Control-Allow-Headers: *\r\nAccess-Control-Allow-Methods: GET, POST, " +
      s"OPTIONS\r\n${extra}Connection: close\r\n\r\n").getBytes("UTF-8"))
    out.flush()
  private def whole(out: OutputStream, status: Int, body: String): Unit =
    val bytes = body.getBytes("UTF-8")
    head(out, status, "application/json", s"Content-Length: ${bytes.length}\r\n")
    out.write(bytes)
    out.flush()

  /** a run asked for: a resume answered, or the next prompt started; refused while a run is on */
  private def run(in: AgUi.RunInput, sink: Sink): Unit =
    val t = synchronized(threads.getOrElseUpdate(in.threadId, Thread_(in.threadId)))
    def refuse(why: String) = { sink.emit(AgUi.runError(why)); sink.finish() }
    t.synchronized {
      t.waiting match
        case Some(id) => in.resume.find(_.interruptId == id) match
            case None => refuse(s"the thread waits for the interrupt $id: resume it")
            case Some(answer) =>
              t.sink = sink
              sink.emit(AgUi.runStarted(t.id, in.runId))
              t.waiting = None
              t.answers.put(answer)
        case None if t.running => refuse("a run of this thread is on")
        case None => in.lastUserText match
            case None => refuse("no user message")
            case Some(text) =>
              t.running = true
              t.sink = sink
              sink.emit(AgUi.runStarted(t.id, in.runId))
              val ctx = t.ctx.fold(AgUiServer.start(text, in.messages, project, budget))(Agent.next(_, text))
              val worker = Thread(() => program(t, ctx), s"agent-${t.id}")
              worker.setDaemon(true)
              worker.start()
    }

  /** the program on a thread's conversation; its events to whichever run is on */
  private def program(t: Thread_, ctx: Ctx): Unit =
    def emit(e: Json) = t.sink.emit(e)
    def message() = { t.messages += 1; s"${t.id}-m${t.messages}" }
    var lastCall: Option[String] = None
    var asked = 0
    // the person, asked through an interrupt: this run ends with it, the next run's resume answers
    def person(question: String): String =
      asked += 1
      val id = s"${t.id}-approve-$asked"
      t.waiting = Some(id)
      emit(AgUi.runInterrupted(t.id, t.sink.runId, Vector(AgUi.approval(id,
        question.replace("allow? [y/N]", "").trim, lastCall))))
      t.sink.finish()
      Option(t.answers.poll(waitFor, TimeUnit.MILLISECONDS)) match
        case Some(r) if r.resolved && r.payload("approved") == Json.Bool(true) => "y"
        case Some(r) => "n" + r.payload.field("reason").collect { case Json.Str(why) => s": $why" }.getOrElse("")
        case None =>
          t.waiting = None
          throw AgUiServer.Cancelled
    type Row[X] = (Llm + Tools + Human + Console)[X]
    val events = AgUiServer.events[Row, (Outcome, Ctx)](call => lastCall = Some(call), message) _
    // the innermost interceptor sees a call first: shown, then admitted, then gated
    val inner = Admit.within[Row, (Outcome, Ctx)](project.tools)(
      events(Compact.within[Row, (Outcome, Ctx)](window)(Agent.runOn[Row](ctx))))
    // with a forecast: asked only when the call or what comes after it is risky — the forecast in the interrupt
    def imagine(c: Call): Obs = if project.tools.find(_.name == c.name).exists(_.kind == ToolSpec.Kind.Read) then
      project.perform(c) else Main.imagined(c)
    val prog = if forecast > 0 then Forecast.gate[Row, (Outcome, Ctx)](project.tools, forecast, imagine)(inner)
      else Gate.asking[Row, (Outcome, Ctx)](project.tools, ask)(inner)
    def check(): Unit = if t.sink.gone then throw AgUiServer.Cancelled
    try
      val (outcome, end) = okay.scala3.run(AgUiServer.lines(e => { check(); emit(Json.fromText(e)) })(Human.by(person)(
        Tools.by { c => check(); project.perform(c) }(Llm.on(model())(prog)))))
      t.ctx = Some(end)
      outcome match
        case Outcome.Done(words) => AgUi.text(message(), words.trim).foreach(emit)
        case Outcome.OutOfBudget(what) => AgUi.text(message(), s"(out of budget: $what)").foreach(emit)
      emit(AgUi.runFinished(t.id, t.sink.runId))
    catch
      case AgUiServer.Cancelled =>
        t.ctx = Some(ctx.copy(messages = ctx.messages :+ Json.obj("role" -> Json.Str("assistant"),
          "content" -> Json.Str("(cancelled)"))))
        emit(AgUi.runCancelled(t.id, t.sink.runId))
      case e: Throwable => emit(AgUi.runError(Option(e.getMessage).getOrElse(e.toString)))
    finally
      t.synchronized { t.running = false; t.waiting = None }
      t.sink.finish()

object AgUiServer:
  case object Cancelled extends Exception("cancelled")

  /** each Console line to `f` */
  def lines[R[_], Rest[_], A](f: String => Unit)(p: A ! R)(using Split[Console, R, Rest]): A ! Rest =
    handle(p, Handler.tail[Console, Rest, A, A](pure)([X] => (op: Console[X]) => op match
      case Console.Line(text) => f(text)))

  /** a thread's first run: the conversation the client sent before it (its user and assistant texts) kept, then the
   * person's words */
  def start(text: String, messages: Vector[Json], p: Project, budget: Budget): Ctx =
    val c = Agent.start(text, p.tools, budget, p.notes)
    val before = messages.dropRight(1).filter(m => Set("user", "assistant")(m("role") match
      case Json.Str(r) => r
      case _ => "")).collect { case m if m.field("content").exists(_.isInstanceOf[Json.Str]) =>
        Json.obj("role" -> m("role"), "content" -> m("content")) }
    c.copy(messages = c.messages.head +: (before :+ c.messages.last))

  /** the program's steps as AG-UI events (each a Console line: an event's JSON): the model's words between calls,
   * each call (its start, arguments, end) before it runs, its result after */
  def events[R[_], A](called: String => Unit, message: () => String)(p: A ! R)
      (using In[Llm, R], In[Tools, R], In[Console, R]): A ! R =
    def out(es: Vector[Json]): Unit ! R =
      es.foldLeft(unit[R])((acc, e) => acc.andThen(Console.line[R](e.render)))
    val turns = around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Finish(_) => proceed.flatMap { f =>
        val words = f.reply.content.trim
        if words.isEmpty || f.reply.toolCalls.isEmpty then pure(f) else out(AgUi.text(message(), words)).as(f)
      }
      case _ => proceed)
    around[Tools, R, A](turns)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) =>
        called(call.id)
        out(AgUi.toolCall(call.id, call.name, call.args)).andThen(proceed.flatMap { o =>
          out(Vector(AgUi.toolResult(message(), call.id, (if o.error then "error: " else "") + o.text.take(4000))))
            .as(o)
        }))
