package okay.agent.cli

import java.nio.file.Files
import okay.agent.Call
import okay.effects.json.Json

/** the workspace's tools: inside it alone, an edit of one exact fragment, globs, commands with their exit */
class WorkspaceSuite extends munit.FunSuite:
  private def call(name: String, args: (String, String)*) =
    Call("c", name, Json.Obj(args.toVector.map((k, v) => k -> Json.Str(v))))
  private def fresh() = Workspace(Files.createTempDirectory("ws"))

  test("files inside the workspace alone: an escape by .. or an absolute path refused"):
    val w = fresh()
    assert(!w.perform(call("write", "path" -> "src/a.txt", "content" -> "one\ntwo\n")).error)
    assertEquals(w.perform(call("read", "path" -> "src/a.txt")).text, "one\ntwo\n")
    assert(w.perform(call("read", "path" -> "../../etc/passwd")).error)
    assert(w.perform(call("write", "path" -> "/tmp/escape.txt", "content" -> "x")).error)
    assert(w.perform(call("read", "path" -> "src/../src/a.txt")).text.startsWith("one"))

  test("edit: one exact fragment; missing or ambiguous, the model told to look again"):
    val w = fresh()
    w.perform(call("write", "path" -> "a.txt", "content" -> "x = 1\ny = 1\n"))
    assert(w.perform(call("edit", "path" -> "a.txt", "old" -> "= 1", "new" -> "= 2")).error, "twice: ambiguous")
    assert(w.perform(call("edit", "path" -> "a.txt", "old" -> "z = 1", "new" -> "z = 2")).error, "absent")
    assert(!w.perform(call("edit", "path" -> "a.txt", "old" -> "y = 1", "new" -> "y = 2")).error)
    assertEquals(w.perform(call("read", "path" -> "a.txt")).text, "x = 1\ny = 2\n")

  test("glob and grep; a command's output and its exit"):
    val w = fresh()
    w.perform(call("write", "path" -> "src/main/A.scala", "content" -> "object A:\n  val x = 42\n"))
    w.perform(call("write", "path" -> "README.md", "content" -> "# x\n"))
    assertEquals(w.perform(call("glob", "pattern" -> "**/*.scala")).text, "src/main/A.scala")
    assertEquals(w.perform(call("glob", "pattern" -> "*.md")).text, "README.md")
    assert(w.perform(call("grep", "pattern" -> "val x", "glob" -> "**/*.scala")).text.contains("src/main/A.scala:2:"))
    assertEquals(w.perform(call("bash", "command" -> "echo hi")).text.trim, "hi")
    val failed = w.perform(call("bash", "command" -> "exit 3"))
    assert(failed.error && failed.text.contains("exit 3"))
