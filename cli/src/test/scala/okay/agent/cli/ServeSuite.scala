package okay.agent.cli

import java.nio.file.{Files, Path}
import okay.agent.{Hypo, ToolSpec}
import okay.effects.json.Json
import okay.llm.{Ask, Server}

/** the AG-UI server: a run's events; a write asked through an interrupt, the program waiting alive, the next run's
 * resume going on with it; a thread's runs one conversation */
class ServeSuite extends munit.FunSuite:
  private def model(ask: Ask): String =
    val users = ask.messages.count(_("role") == Json.Str("user"))
    val since = ask.messages.reverse.takeWhile(_("role") != Json.Str("user")).count(_("role") == Json.Str("assistant"))
    if users >= 2 then s"remembered ${users - 1} earlier prompt"
    else since match
      case 0 => Hypo.call("edit", """{"path": "a.txt", "old": "hello", "new": "bye"}""")
      case 1 => Hypo.call("bash", """{"command": "cat a.txt"}""")
      case _ => "changed it"

  private def start(): (Path, Int) =
    val root = Files.createTempDirectory("agui").toRealPath()
    Files.writeString(root.resolve("a.txt"), "hello")
    val server = AgUiServer(root, () => Hypo.backend(model), _ == ToolSpec.Kind.Write, mcp = _ => Vector.empty)
    val socket = java.net.ServerSocket(0)
    val port = socket.getLocalPort
    socket.close()
    val t = Thread(() => Server.run(port)(server.serve))
    t.setDaemon(true)
    t.start()
    Thread.sleep(300)
    (root, port)

  /** a run: its events, as the stream gave them */
  private def post(port: Int, body: Json): Vector[Json] =
    val s = java.net.Socket("127.0.0.1", port)
    try
      val b = body.render.getBytes("UTF-8")
      s.getOutputStream.write((s"POST /agent HTTP/1.1\r\nHost: x\r\nContent-Type: application/json\r\n" +
        s"Accept: text/event-stream\r\nContent-Length: ${b.length}\r\n\r\n").getBytes("UTF-8") ++ b)
      val text = String(s.getInputStream.readAllBytes(), "UTF-8")
      text.substring(text.indexOf("\r\n\r\n") + 4).split("\n\n").toVector.filter(_.startsWith("data: "))
        .map(l => Json.fromText(l.stripPrefix("data: ")))
    finally s.close()

  private def input(thread: String, run: String, text: String, resume: Json = Json.Null) =
    Json.Obj(Vector("threadId" -> Json.Str(thread), "runId" -> Json.Str(run), "messages" -> Json.arr(
      Json.obj("id" -> Json.Str(run + "-u"), "role" -> Json.Str("user"), "content" -> Json.Str(text)))) ++
      (if resume == Json.Null then Vector.empty else Vector("resume" -> resume)))
  private def answer(id: String, approved: Boolean, why: String = "") = Json.arr(Json.obj(
    "interruptId" -> Json.Str(id), "status" -> Json.Str("resolved"), "payload" -> Json.obj(
      "approved" -> Json.Bool(approved), "reason" -> Json.Str(why))))
  private def types(es: Vector[Json]) = es.map(_("type").string)

  test("a write asked: the run ends with an interrupt; resumed, the program goes on; the thread's next run too"):
    val (root, port) = start()
    val first = post(port, input("t1", "r1", "say bye"))
    assertEquals(types(first), Vector("RUN_STARTED", "TOOL_CALL_START", "TOOL_CALL_ARGS", "TOOL_CALL_END",
      "RUN_FINISHED"))
    val interrupt = first.last("outcome")("interrupts").list.head
    assertEquals(first.last("outcome")("type").string, "interrupt")
    assertEquals(interrupt("toolCallId"), first(1)("toolCallId"))
    assertEquals(Files.readString(root.resolve("a.txt")), "hello")
    // a new prompt while it waits: refused
    assertEquals(types(post(port, input("t1", "rx", "other"))), Vector("RUN_ERROR"))
    val second = post(port, input("t1", "r2", "say bye", answer(interrupt("id").string, approved = true)))
    assertEquals(Files.readString(root.resolve("a.txt")), "bye")
    assertEquals(types(second).head, "RUN_STARTED")
    assertEquals(second.last("outcome")("type").string, "success")
    // the words as they came: one message, a piece at a time
    def text(es: Vector[Json]) = es.filter(_("type") == Json.Str("TEXT_MESSAGE_CONTENT")).map(_("delta").string)
    assert(text(second).size > 1)
    assertEquals(text(second).mkString, "changed it")
    assertEquals(second.count(_("type") == Json.Str("TEXT_MESSAGE_START")), 1)
    assertEquals(second.count(_("type") == Json.Str("TEXT_MESSAGE_END")), 1)
    assertEquals(second.filter(_("type") == Json.Str("TOOL_CALL_RESULT")).map(_("content").string),
      Vector("edited a.txt", "bye"))
    val third = post(port, input("t1", "r3", "and now?"))
    assertEquals(text(third).mkString, "remembered 1 earlier prompt")

  test("a write refused: the model told why, the file as it was"):
    val (root, port) = start()
    val first = post(port, input("t2", "r1", "say bye"))
    val id = first.last("outcome")("interrupts").list.head("id").string
    val second = post(port, input("t2", "r2", "say bye", answer(id, approved = false, "not now")))
    assertEquals(Files.readString(root.resolve("a.txt")), "hello")
    assert(second.exists(e => e("type") == Json.Str("TOOL_CALL_RESULT") &&
      e("content").string.contains("did not allow it: n: not now")), second.toString)
