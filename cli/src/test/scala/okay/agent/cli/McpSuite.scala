package okay.agent.cli

import java.nio.file.{Files, Path}
import okay.agent.ToolSpec
import okay.effects.json.Json

/** a project's MCP servers: found with no setting, started, their tools the agent's */
class McpSuite extends munit.FunSuite:
  private def fakeServer(dir: Path): Path =
    val script = dir.resolve("fake_mcp.py")
    Files.writeString(script, scala.io.Source.fromInputStream(getClass.getResourceAsStream("/fake_mcp.py")).mkString)
    script

  test("a server started: initialized past a notification and a ping, its tools listed, a call answered"):
    val dir = Files.createTempDirectory("mcp")
    val (servers, specs, routes) = Mcp.attach(dir, Vector(Mcp.Server("fake", List("python3",
      fakeServer(dir).toString))), Set("read", "write"), m => fail(m))
    try
      assertEquals(specs.map(s => s.name -> s.kind), Vector("lookup" -> ToolSpec.Kind.Read,
        "fake_read" -> ToolSpec.Kind.Exec))   // its "read" takes its server's prefix; not read-only: asked about
      val (server, tool) = routes("lookup")
      assertEquals(server.call(tool, Json.obj("q" -> Json.Str("x"))).text, """lookup {"q": "x"}""")
      assertEquals(routes("fake_read")._2, "read")
    finally servers.foreach(_.close())

  test("found with no setting: .mcp.json's stdio servers; symdex not twice"):
    val dir = Files.createTempDirectory("proj")
    Files.writeString(dir.resolve(".mcp.json"), """{"mcpServers": {
      "symdex": {"command": "/x/symdex", "args": ["serve", "--root", "."]},
      "web": {"type": "http", "url": "http://localhost:1"},
      "other": {"command": "node", "args": ["s.js"], "env": {"K": "v"}}}}""")
    assertEquals(Mcp.fromMcpJson(dir), Vector(Mcp.Server("symdex", List("/x/symdex", "serve", "--root", ".")),
      Mcp.Server("other", List("node", "s.js"), Map("K" -> "v"))))
    // an index here too: symdex is listed already, so not added again — and its path gone, the installed one run
    Files.createDirectories(dir.resolve("target/meta/META-INF/semanticdb"))
    val found = Mcp.found(dir, () => Some("/installed/symdex"))
    assertEquals(found.count(_.name == "symdex"), 1)
    assertEquals(found.find(_.name == "symdex").map(_.command),
      Some(List("/installed/symdex", "serve", "--root", ".")))

  test("an index for symdex: SemanticDB a compile wrote, or a SCIP file; none in a bare project"):
    val bare = Files.createTempDirectory("bare")
    Files.writeString(bare.resolve("a.scala"), "object A")
    assert(!Mcp.indexed(bare))
    val compiled = Files.createTempDirectory("compiled")
    Files.createDirectories(compiled.resolve("core/target/scala-3/meta/META-INF/semanticdb/src"))
    assert(Mcp.indexed(compiled))
    val scip = Files.createTempDirectory("scip")
    Files.writeString(scip.resolve("index.scip"), "")
    assert(Mcp.indexed(scip))

/** a grep for a symbol that found nothing, with symdex here: the model told to ask symdex's references */
class NudgeSuite extends munit.FunSuite:
  private def grep(p: String) = okay.agent.Call("c", "grep", Json.obj("pattern" -> Json.Str(p)))
  test("nothing found for a symbol, symdex here: references suggested; else the observation as it was"):
    val none = okay.agent.Obs("no match")
    assert(Main.nudged(grep("Pricing\\.price"), none, symdex = true).text.contains("references query=Pricing.price"))
    assertEquals(Main.nudged(grep("Pricing\\.price"), none, symdex = false), none)
    assertEquals(Main.nudged(grep("TODO: fix .*"), none, symdex = true), none)
    val found = okay.agent.Obs("a.scala:1: x")
    assertEquals(Main.nudged(grep("x"), found, symdex = true), found)
