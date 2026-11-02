package okay.agent.cli

import java.nio.charset.StandardCharsets.UTF_8
import java.nio.file.{Files, StandardOpenOption}
import okay.agent.{Obs, ToolSpec}
import okay.effects.json.Json

/** SYMDEX SET UP in an sbt project, by one tool, done the same way each time: its plugin in project/plugins.sbt
 * (the lines its guide gives), then `sbt symdexIndex symdexMcp` — every project compiled with SemanticDB, the server
 * put in .mcp.json. A local model need not know the plugin's coordinates; from the next run its tools are the
 * agent's */
object Symdex:
  val version = "0.6.0"
  val lines: Vector[String] = Vector(
    """resolvers += Resolver.url("symdex", url("https://okay-effects.github.io/symdex"))(Resolver.ivyStylePatterns)""",
    s"""addSbtPlugin("io.github.sergey-scherbina" % "sbt-symdex" % "$version")""")

  val spec: ToolSpec = ToolSpec("symdex_setup",
    "Set up symdex (code intelligence: definitions, references, callers, implementations) in this sbt project: adds " +
      "its plugin, compiles with SemanticDB, registers it. Its tools come with the next run.",
    Json.obj("type" -> Json.Str("object"), "properties" -> Json.obj()), ToolSpec.Kind.Write)

  def setup(w: Workspace): Obs =
    val root = w.root
    if !Files.exists(root.resolve("build.sbt")) then Obs("not an sbt project (no build.sbt)", error = true)
    else
      val plugins = root.resolve("project/plugins.sbt")
      Files.createDirectories(plugins.getParent)
      val had = if Files.exists(plugins) then Files.readString(plugins, UTF_8) else ""
      val added = if had.contains("sbt-symdex") then 0 else
        val sep = if had.isEmpty || had.endsWith("\n") then "" else "\n"
        Files.writeString(plugins, sep + lines.mkString("", "\n", "\n"), UTF_8, StandardOpenOption.CREATE,
          StandardOpenOption.APPEND)
        lines.size
      val built = w.run("sbt -batch symdexIndex symdexMcp", 1800)
      val tail = built.text.linesIterator.toVector.takeRight(12).mkString("\n")
      if built.error then
        Obs(s"project/plugins.sbt: +$added lines; sbt symdexIndex symdexMcp failed:\n$tail", error = true)
      else Obs(s"symdex set up — project/plugins.sbt: +$added lines; indexed and registered in .mcp.json:\n$tail\n" +
        "Its tools (definition, references, callers…) come with the next run.")
