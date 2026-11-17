package okay.agent.cli

import java.nio.file.{Files, Path}
import okay.agent.{Hypo, ToolSpec}
import okay.effects.json.Json
import okay.llm.{Ask, Server}

/** okay-agent as a model (opencode's): a session's messages one conversation; a command asked in the reply, the
 * program waiting alive, the session's next message its answer — a yes performs it, a no is the model's observation;
 * a request without tools the plain model's */
class OpenAiFaceSuite extends munit.FunSuite:
  /** the hypothetical model: edits, then runs a command, then answers; a title asked of it plainly */
  private def model(ask: Ask): String =
    if ask.tools.isEmpty then "A title"
    else
      val users = ask.messages.count(_("role") == Json.Str("user"))
      val since = ask.messages.reverse.takeWhile(_("role") != Json.Str("user"))
        .count(_("role") == Json.Str("assistant"))
      val last = ask.messages.lastOption.flatMap(_.field("content")).collect { case Json.Str(t) => t }.getOrElse("")
      if users >= 2 then s"remembered ${users - 1} earlier message"
      else since match
        case 0 => Hypo.call("edit", """{"path": "a.txt", "old": "hello", "new": "bye"}""")
        case 1 => Hypo.call("bash", """{"command": "cat a.txt"}""")
        case _ => if last.contains("did not allow") then "not run: " + last else "changed it"

  private def start(): (Path, Int) =
    val root = Files.createTempDirectory("openai").toRealPath()
    Files.writeString(root.resolve("a.txt"), "hello")
    val face = OpenAiFace("http://127.0.0.1:1/v1", _ == ToolSpec.Kind.Exec, 30, Some(_ => Hypo.backend(model)),
      _ => Vector.empty)
    val socket = java.net.ServerSocket(0)
    val port = socket.getLocalPort
    socket.close()
    val t = Thread(() => Server.run(port)(face.serve))
    t.setDaemon(true)
    t.start()
    Thread.sleep(300)
    (root, port)

  /** a request: the reply's text, as its chunks gave it */
  private def post(port: Int, root: Path, session: String, messages: Vector[(String, String)],
      tools: Boolean = true): String =
    val body = Json.obj("model" -> Json.Str("m"), "stream" -> Json.Bool(true),
      "messages" -> Json.Arr(messages.map((r, c) => Json.obj("role" -> Json.Str(r), "content" -> Json.Str(c)))),
      "tools" -> (if tools then Json.arr(Json.obj("type" -> Json.Str("function"))) else Json.arr()))
    val s = java.net.Socket("127.0.0.1", port)
    try
      val b = body.render.getBytes("UTF-8")
      s.getOutputStream.write((s"POST /v1/chat/completions HTTP/1.1\r\nHost: x\r\nContent-Type: application/json\r\n" +
        s"x-opencode-session-id: $session\r\nx-okay-directory: $root\r\nContent-Length: ${b.length}\r\n\r\n")
        .getBytes("UTF-8") ++ b)
      val text = String(s.getInputStream.readAllBytes(), "UTF-8")
      val chunks = text.substring(text.indexOf("\r\n\r\n") + 4).split("\n\n").toVector.filter(_.startsWith("data: "))
        .map(_.stripPrefix("data: "))
      assertEquals(chunks.last, "[DONE]")
      chunks.init.map(Json.fromText).flatMap(_("choices").list.head("delta").field("content"))
        .collect { case Json.Str(t) => t }.mkString
    finally s.close()

  test("a session: the edit done, the command asked; yes runs it, the conversation goes on in the next message"):
    val (root, port) = start()
    val first = post(port, root, "s1", Vector("system" -> "opencode's", "user" -> "say bye"))
    assert(first.contains("▸ `edit`"), first)
    assert(first.contains("▸ `bash` cat a.txt") && first.contains("**okay-agent asks:**"), first)
    assertEquals(Files.readString(root.resolve("a.txt")), "bye")
    val second = post(port, root, "s1", Vector("user" -> "say bye", "assistant" -> first, "user" -> "yes"))
    assert(second.startsWith("*allowed*"), second)
    assert(second.contains("✓ 1 line") && second.contains("changed it"), second)
    val third = post(port, root, "s1", Vector("user" -> "say bye", "assistant" -> first, "user" -> "yes",
      "assistant" -> second, "user" -> "and now?"))
    assert(third.contains("remembered 1 earlier message"), third)

  test("a no: never run, its reason the model's observation"):
    val (root, port) = start()
    val first = post(port, root, "s2", Vector("user" -> "say bye"))
    assert(first.contains("**okay-agent asks:**"), first)
    val second = post(port, root, "s2", Vector("user" -> "say bye", "assistant" -> first,
      "user" -> "no, do not cat it"))
    assert(second.startsWith("*not allowed: do not cat it*"), second)
    assert(second.contains("not run:") && second.contains("do not cat it"), second)

  test("no tools: the plain model answers (opencode's title)"):
    val (root, port) = start()
    assertEquals(post(port, root, "s3", Vector("user" -> "name this"), tools = false), "A title")

  test("answers read: yes words allow, anything else is a no with its reason"):
    assertEquals(OpenAiFace.answer("yes"), (true, ""))
    assertEquals(OpenAiFace.answer("Да"), (true, ""))
    assertEquals(OpenAiFace.answer("ok, go"), (true, ""))
    assertEquals(OpenAiFace.answer("no, use sbt"), (false, "use sbt"))
    assertEquals(OpenAiFace.answer("нет"), (false, ""))
    assertEquals(OpenAiFace.answer("rather run the tests first"), (false, "rather run the tests first"))

  test("the directory read from opencode's system prompt when no header names it"):
    val sys = Json.obj("role" -> Json.Str("system"), "content" -> Json.Str(
      "You are opencode.\n<env>\n  Working directory: /tmp/x y\n  Is directory a git repo: yes\n</env>"))
    assertEquals(OpenAiFace.directoryOf(Vector(sys)), Some("/tmp/x y"))
