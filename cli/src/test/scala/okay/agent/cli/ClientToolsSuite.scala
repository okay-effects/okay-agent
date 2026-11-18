package okay.agent.cli

import java.nio.file.{Files, Path}
import okay.agent.{Admit, Call, Hypo, ToolSpec}
import okay.effects.json.Json
import okay.llm.{Ask, Server}
import scala.util.Random

/** THE CLIENT'S TOOLS (okay-agent openai, its default), over a client that plays opencode: it performs each call the
 * reply hands it and sends the result back as a `tool` message. Laws: every call the client gets was admitted, and
 * the program the client's results go back to is the SAME one, alive (its requests extend each other — no new start);
 * a call off its schema never reaches the client; a new user message mid-wait goes on in the conversation */
class ClientToolsSuite extends munit.FunSuite:
  private def s(t: String) = Json.Str(t)
  private def obj(props: (String, String)*) = Json.obj("type" -> s("object"),
    "properties" -> Json.Obj(props.toVector.map((n, t) => n -> Json.obj("type" -> s(t)))),
    "required" -> Json.Arr(props.toVector.map(p => s(p._1))))
  /** opencode's tools, as its requests offer them: long descriptions */
  private val offered = Vector(
    "read" -> obj("filePath" -> "string"), "write" -> obj("filePath" -> "string", "content" -> "string"),
    "bash" -> obj("command" -> "string")).map((n, p) => Json.obj("type" -> s("function"), "function" -> Json.obj(
      "name" -> s(n), "description" -> s(s"Does $n. " + "Usage notes that go on and on. " * 40), "parameters" -> p)))
  private val specs = ClientTools.specs(offered)

  private def start(model: Ask => String): (Path, Int) =
    val root = Files.createTempDirectory("client").toRealPath()
    Files.writeString(root.resolve("a.txt"), "hello")
    val face = OpenAiFace("http://127.0.0.1:1/v1", _ => false, 30, Some(_ => Hypo.backend(model)), _ => Vector.empty,
      journals = false)
    val socket = java.net.ServerSocket(0)
    val port = socket.getLocalPort
    socket.close()
    val t = Thread(() => Server.run(port)(face.serve))
    t.setDaemon(true)
    t.start()
    Thread.sleep(300)
    (root, port)

  /** a reply as the client reads it: its words, the call it hands over, how it finished */
  case class Got(text: String, call: Option[(String, String, String)], finish: String)

  private def post(port: Int, root: Path, session: String, messages: Vector[Json]): Got =
    val body = Json.obj("model" -> s("m"), "stream" -> Json.Bool(true), "messages" -> Json.Arr(messages),
      "tools" -> Json.Arr(offered))
    val sock = java.net.Socket("127.0.0.1", port)
    try
      val b = body.render.getBytes("UTF-8")
      sock.getOutputStream.write((s"POST /v1/chat/completions HTTP/1.1\r\nHost: x\r\n" +
        s"x-opencode-session-id: $session\r\nx-okay-directory: $root\r\nContent-Length: ${b.length}\r\n\r\n")
        .getBytes("UTF-8") ++ b)
      val text = String(sock.getInputStream.readAllBytes(), "UTF-8")
      val chunks = text.substring(text.indexOf("\r\n\r\n") + 4).split("\n\n").toVector.filter(_.startsWith("data: "))
        .map(_.stripPrefix("data: "))
      assertEquals(chunks.last, "[DONE]")
      val choices = chunks.init.map(Json.fromText).map(_("choices").list.head)
      val words = choices.flatMap(_("delta").field("content")).collect { case Json.Str(t) => t }.mkString
      val calls = choices.flatMap(_("delta").field("tool_calls")).flatMap(_.list).map(c =>
        (c("id").string, c("function")("name").string, c("function")("arguments").string))
      assert(calls.size <= 1, s"one call a reply: $calls")
      Got(words, calls.headOption, choices.flatMap(_.field("finish_reason")).collect { case Json.Str(f) => f }.last)
    finally sock.close()

  /** the client: each call it is handed performed by `perform`, its result sent back, until the reply ends */
  private def converse(port: Int, root: Path, session: String, first: Vector[Json], perform: Call => String,
      limit: Int = 60): (Vector[Json], Got) =
    var messages = first
    var got = post(port, root, session, messages)
    var n = 0
    while got.call.isDefined && n < limit do
      val (id, name, args) = got.call.get
      assertEquals(got.finish, "tool_calls")
      val result = perform(Call(id, name, Json.fromText(args)))
      messages = messages :+ Json.obj("role" -> s("assistant"), "content" -> s(got.text), "tool_calls" -> Json.arr(
        Json.obj("id" -> s(id), "type" -> s("function"), "function" -> Json.obj("name" -> s(name),
          "arguments" -> s(args))))) :+ Json.obj("role" -> s("tool"), "tool_call_id" -> s(id), "content" -> s(result))
      got = post(port, root, session, messages)
      n += 1
    (messages, got)

  private def user(t: String) = Json.obj("role" -> s("user"), "content" -> s(t))

  test("every call the client gets was admitted; its results go back to the same program, alive (requests extend)"):
    var made, reached = 0
    for seed <- 1 to 40 do
      val r = Random(seed)
      val asks = Vector.newBuilder[Ask]
      val (root, port) = start { a =>
        asks += a
        if r.nextDouble() < 0.12 then "Done."
        else
          made += 1
          val name = Vector("read", "write", "bash", "rm_rf", "Read")(r.nextInt(5))
          val args = Vector("""{"filePath": "/x/a.txt"}""", """{"filePath": "/x/b", "content": "1"}""",
            """{"command": "ls"}""", """{}""", """{"filePath": 7}""")(r.nextInt(5))
          Hypo.call(name, args)
      }
      val performed = Vector.newBuilder[Call]
      val (_, end) = converse(port, root, s"law-$seed", Vector(user("go")), c => { performed += c; s"ok ${c.name}" })
      assertEquals(end.finish, "stop", s"seed $seed")
      val calls = performed.result()
      reached += calls.size
      calls.foreach(c => assertEquals(Admit.refusal(specs, c), None, s"seed $seed: $c reached the client"))
      // the same program: each request the model got extends the last — never a new start
      asks.result().map(_.messages).sliding(2).foreach {
        case Seq(a, b) => assertEquals(b.take(a.length), a, s"seed $seed: the program began again")
        case _ => ()
      }
      // the client performed the calls, not okay-agent: the project as it was
      assertEquals(Files.list(root).count(), 1L)
    assert(reached > 0 && reached < made, s"$reached of $made calls reached the client")

  test("the client's result is what the model reads next; a call off its schema never reaches the client"):
    val (root, port) = start { a =>
      val since = a.messages.reverse.takeWhile(_("role") != s("user")).count(_("role") == s("assistant"))
      val last = a.messages.last.field("content").collect { case Json.Str(t) => t }.getOrElse("")
      since match
        case 0 => Hypo.call("write", """{"content": "x"}""") // no filePath: refused
        case 1 => Hypo.call("read", """{"filePath": "/p/a.txt"}""")
        case _ => s"read: $last"
    }
    val handed = Vector.newBuilder[String]
    val (_, end) = converse(port, root, "c1", Vector(user("read a")),
      c => { handed += c.name; "the client's text" })
    assertEquals(handed.result(), Vector("read"))
    assert(end.text.contains("read: the client's text"), end.text)

  test("a new user message while a call waits: that program cancelled, the conversation going on from it"):
    val (root, port) = start { a =>
      val users = a.messages.count(_("role") == s("user"))
      if users >= 2 then s"remembered ${users - 1} earlier message" else Hypo.call("bash", """{"command": "ls"}""")
    }
    val first = post(port, root, "c2", Vector(user("list")))
    assertEquals(first.finish, "tool_calls")
    val (id, name, args) = first.call.get
    val second = post(port, root, "c2", Vector(user("list"), Json.obj("role" -> s("assistant"), "content" -> s(""),
      "tool_calls" -> Json.arr(Json.obj("id" -> s(id), "type" -> s("function"), "function" -> Json.obj(
        "name" -> s(name), "arguments" -> s(args))))), user("never mind")))
    assertEquals(second.finish, "stop")
    assert(second.text.contains("remembered 1 earlier message"), second.text)

  test("the client's tools read: descriptions to a first sentence, kinds by name"):
    assertEquals(specs.map(_.description), Vector("Does read.", "Does write.", "Does bash."))
    assertEquals(specs.map(_.kind), Vector(ToolSpec.Kind.Read, ToolSpec.Kind.Write, ToolSpec.Kind.Exec))
    assertEquals(ClientTools.kind("edit"), ToolSpec.Kind.Write)
    assertEquals(ClientTools.kind("grep"), ToolSpec.Kind.Read)
    assert(ClientTools.failed("Error: file not found"))
