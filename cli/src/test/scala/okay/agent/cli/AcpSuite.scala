package okay.agent.cli

import java.io.{BufferedReader, PipedReader, PipedWriter}
import java.nio.file.{Files, Path}
import java.util.concurrent.LinkedBlockingQueue
import okay.agent.Hypo
import okay.effects.json.Json
import okay.llm.Ask

/** the ACP agent with a client of the test's: its files through fs requests, its commands through terminal ones,
 * each call shown, a session's prompts in one conversation */
class AcpSuite extends munit.FunSuite:
  /** the model: edit, look, done — then, on a second prompt, a reply naming what it remembers */
  private def model(ask: Ask): String =
    val users = ask.messages.count(_("role") == Json.Str("user"))
    val since = ask.messages.reverse.takeWhile(_("role") != Json.Str("user")).count(_("role") == Json.Str("assistant"))
    if users >= 2 then s"remembered ${users - 1} earlier prompt"
    else since match
      case 0 => Hypo.call("edit", """{"path": "a.txt", "old": "hello", "new": "bye"}""")
      case 1 => Hypo.call("bash", """{"command": "cat a.txt"}""")
      case _ => "changed it"

  /** `hang`: a command that never ends by itself — its wait answered only when it is killed; `cancel`: the person
   * cancels while it runs */
  private final class Client(root: Path, refuseWrites: Boolean = false, hang: Boolean = false,
      cancel: Boolean = false, timeout: Int = 300, answers: Ask => String = model, forecast: Int = 0,
      journals: Option[Path] = None):
    private val toAgent = PipedWriter()
    private val agentIn = BufferedReader(PipedReader(toAgent))
    val got = LinkedBlockingQueue[Json]()
    val seen = scala.collection.mutable.ArrayBuffer.empty[Json]
    private var n = 0
    private val agent = AcpAgent(agentIn, line => got.put(Json.fromText(line)), _ => Hypo.backend(answers),
      mcp = _ => Vector.empty, timeoutSeconds = timeout, forecast = forecast,
      journal = _ => journals.map { d => n += 1; d.resolve(s"prompt-$n.jsonl") })
    private var waiting: Option[Json] = None
    var sid: Json = Json.Null
    private val thread = Thread(() => agent.serve())
    thread.setDaemon(true)
    thread.start()
    private var id = 100
    def send(j: Json): Unit = { toAgent.write(j.render + "\n"); toAgent.flush() }
    private def answer(id: Json, result: Json) = send(Json.obj("jsonrpc" -> Json.Str("2.0"), "id" -> id,
      "result" -> result))
    /** a request of the client's, the agent's requests served meanwhile; its result */
    def call(method: String, params: Json): Json =
      id += 1
      send(Json.obj("jsonrpc" -> Json.Str("2.0"), "id" -> Json.num(id), "method" -> Json.Str(method),
        "params" -> params))
      var result: Option[Json] = None
      while result.isEmpty do
        val m = got.take()
        seen += m
        (m.field("id"), m.field("method").map(_.string)) match
          case (Some(i), None) if i == Json.num(id) => result = Some(m("result"))
          case (Some(i), Some(asked)) => serve(i, asked, m("params"))
          case _ => ()
      result.get
    private def serve(i: Json, method: String, p: Json): Unit = method match
      case "fs/read_text_file" =>
        answer(i, Json.obj("content" -> Json.Str(Files.readString(Path.of(p("path").string)))))
      case "fs/write_text_file" =>
        if refuseWrites then send(Json.obj("jsonrpc" -> Json.Str("2.0"), "id" -> i, "error" -> Json.obj(
          "code" -> Json.num(-32000), "message" -> Json.Str("okay-guard: not written — denied"))))
        else
          Files.writeString(Path.of(p("path").string), p("content").string)
          answer(i, Json.Null)
      case "terminal/create" =>
        assertEquals(p("cwd").string, root.toString)
        answer(i, Json.obj("terminalId" -> Json.Str("t1")))
      case "terminal/wait_for_exit" =>
        if !hang then answer(i, Json.obj("exitCode" -> Json.num(0)))
        else
          waiting = Some(i)
          if cancel then send(Json.obj("jsonrpc" -> Json.Str("2.0"), "method" -> Json.Str("session/cancel"),
            "params" -> Json.obj("sessionId" -> sid)))
      case "terminal/kill" =>
        answer(i, Json.Null)
        waiting.foreach(w => answer(w, Json.obj("exitCode" -> Json.num(137))))
        waiting = None
      case "terminal/output" => answer(i, Json.obj("output" -> Json.Str(Files.readString(root.resolve("a.txt")))))
      case "session/request_permission" => answer(i, Json.obj("outcome" -> Json.obj(
          "outcome" -> Json.Str("selected"), "optionId" -> Json.Str("allow"))))
      case _ => answer(i, Json.Null)
    def updates: Vector[Json] = seen.toVector.filter(_.field("method").contains(Json.Str("session/update")))
      .map(_("params")("update"))
    def close(): Unit = toAgent.close()

  private def project(): Path =
    val d = Files.createTempDirectory("acp").toRealPath()
    Files.writeString(d.resolve("a.txt"), "hello")
    d

  private val caps = Json.obj("protocolVersion" -> Json.num(1), "clientCapabilities" -> Json.obj(
    "fs" -> Json.obj("readTextFile" -> Json.Bool(true), "writeTextFile" -> Json.Bool(true)),
    "terminal" -> Json.Bool(true)))

  private def prompt(c: Client, sid: Json, text: String) = c.call("session/prompt", Json.obj("sessionId" -> sid,
    "prompt" -> Json.arr(Json.obj("type" -> Json.Str("text"), "text" -> Json.Str(text)))))

  test("a prompt: the file edited through the client, the command run by it, each call shown; the next goes on"):
    val root = project()
    val c = Client(root)
    assertEquals(c.call("initialize", caps)("protocolVersion"), Json.num(1))
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    assertEquals(prompt(c, sid, "say bye")("stopReason"), Json.Str("end_turn"))
    assertEquals(Files.readString(root.resolve("a.txt")), "bye")
    val asked = c.seen.flatMap(_.field("method").map(_.string)).toVector
    assert(asked.containsSlice(Vector("fs/read_text_file", "fs/write_text_file")), asked)
    assert(asked.contains("terminal/create") && asked.contains("terminal/release"), asked)
    val calls = c.updates.filter(_("sessionUpdate") == Json.Str("tool_call"))
    assertEquals(calls.map(_("kind").string), Vector("edit", "execute"))
    assertEquals(calls.head("rawInput")("file_path").string, root.resolve("a.txt").toString)
    assertEquals(calls(1)("rawInput")("command").string, "cat a.txt")
    val ends = c.updates.filter(_("sessionUpdate") == Json.Str("tool_call_update")).map(_("status").string)
    assertEquals(ends, Vector("completed", "completed"))
    // the model's words as they came, a piece at a time (each word, here), said once
    def said = c.updates.filter(_("sessionUpdate") == Json.Str("agent_message_chunk"))
      .map(_("content")("text").string)
    assert(said.size > 2, said.toString)
    assertEquals(said.mkString, "changed it\n")
    // the second prompt: the same conversation
    assertEquals(prompt(c, sid, "and now?")("stopReason"), Json.Str("end_turn"))
    assert(said.mkString.endsWith("remembered 1 earlier prompt\n"), said.toString)
    c.close()

  test("a command that runs too long: killed by the agent's watchdog, the model told; a cancel kills it at once"):
    val root = project()
    val c = Client(root, hang = true, timeout = 1)
    c.call("initialize", caps)
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    val t0 = System.nanoTime()
    assertEquals(prompt(c, sid, "say bye")("stopReason"), Json.Str("end_turn"))
    assert((System.nanoTime() - t0) / 1e9 < 10)
    val bash = c.updates.filter(_("sessionUpdate") == Json.Str("tool_call_update"))(1)
    assertEquals(bash("status").string, "failed")
    assert(bash("content").list.head("content")("text").string.contains("(stopped after 1s)"), bash.toString)
    c.close()
    // cancelled while the command runs: killed, the prompt ends cancelled (no waiting for the timeout)
    val other = project()
    val d = Client(other, hang = true, cancel = true, timeout = 600)
    d.call("initialize", caps)
    d.sid = d.call("session/new", Json.obj("cwd" -> Json.Str(other.toString), "mcpServers" -> Json.arr()))("sessionId")
    assertEquals(prompt(d, d.sid, "say bye")("stopReason"), Json.Str("cancelled"))
    d.close()

  test("each prompt journalled, its conversation so far in its start: replayed alone, the same end"):
    val root = project()
    val dir = Files.createTempDirectory("journals")
    val c = Client(root, journals = Some(dir))
    c.call("initialize", caps)
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    prompt(c, sid, "say bye")
    prompt(c, sid, "and now?")
    c.close()
    def entries(n: Int) = Files.readAllLines(dir.resolve(s"prompt-$n.jsonl")).toArray.toVector
      .map(l => Json.fromText(l.toString))
    assertEquals(Main.replayed(entries(1), _ => ()), okay.agent.Outcome.Done("changed it"))
    // the second prompt alone: from the conversation it began with
    assertEquals(Main.replayed(entries(2), _ => ()), okay.agent.Outcome.Done("remembered 1 earlier prompt"))
    assert(entries(2).head("messages").list.size > 3)

  test("with a forecast: a call with a commit ahead asked through the client, the forecast said first"):
    val root = project()
    val script: Ask => String = a => a.messages.count(_.field("tool_calls").isDefined) match
      case 0 => Hypo.call("edit", """{"path": "a.txt", "old": "hello", "new": "bye"}""")
      case 1 => Hypo.call("git_commit", """{"message": "bye"}""")
      case _ => "committed"
    val c = Client(root, answers = script, forecast = 3)
    c.call("initialize", caps)
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    assertEquals(prompt(c, sid, "say bye and commit")("stopReason"), Json.Str("end_turn"))
    val asked = c.seen.filter(_.field("method").contains(Json.Str("session/request_permission")))
    assertEquals(asked.map(_("params")("toolCall")("toolCallId").string).toVector, Vector("call_0_0", "call_1_0"))
    assertEquals(asked.head("params")("toolCall")("rawInput")("file_path").string, root.resolve("a.txt").toString)
    val said = c.updates.filter(_("sessionUpdate") == Json.Str("agent_message_chunk")).map(_("content")("text").string)
    assert(said.exists(_.contains("forecast: then git_commit bye")), said.toString)
    c.close()

  test("a write the client refuses: the call failed, the agent told why"):
    val root = project()
    val c = Client(root, refuseWrites = true)
    c.call("initialize", caps)
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    assertEquals(prompt(c, sid, "say bye")("stopReason"), Json.Str("end_turn"))
    assertEquals(Files.readString(root.resolve("a.txt")), "hello")
    val first = c.updates.find(_("sessionUpdate") == Json.Str("tool_call_update")).get
    assertEquals(first("status").string, "failed")
    assert(first("content").list.head("content")("text").string.contains("denied"))
    c.close()

  test("a client with no fs nor terminal: the workspace's own tools"):
    val root = project()
    val c = Client(root)
    c.call("initialize", Json.obj("protocolVersion" -> Json.num(1), "clientCapabilities" -> Json.obj()))
    val sid = c.call("session/new", Json.obj("cwd" -> Json.Str(root.toString), "mcpServers" -> Json.arr()))("sessionId")
    assertEquals(prompt(c, sid, "say bye")("stopReason"), Json.Str("end_turn"))
    assertEquals(Files.readString(root.resolve("a.txt")), "bye")
    assert(!c.seen.exists(_.field("method").exists(m => m.string.startsWith("fs/"))))
    c.close()
