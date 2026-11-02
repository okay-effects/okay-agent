package okay.agent.cli

import java.nio.file.Path
import okay.agent.{Call, Obs, ToolSpec}

/** A PROJECT the agent works in, as a server's session has it: the workspace, the project's MCP servers (its
 * .mcp.json, symdex where an index is) started, the tools offered, the notes on them; a call performed here */
final class Project(val root: Path, mcp: Path => Vector[Mcp.Server], timeoutSeconds: Int = 300):
  val ws: Workspace = Workspace(root, timeoutSeconds)
  val (servers, served, routes) = Mcp.attach(root, mcp(root), Workspace.tools.map(_.name).toSet, _ => ())
  val symdex: Boolean = servers.exists(_.name == "symdex")
  val tools: Vector[ToolSpec] = Workspace.tools ++ served
  val notes: Vector[String] = if symdex then Vector(Project.symdexNote) else Vector.empty

  /** an MCP server's tool, or symdex_setup, or the workspace's */
  def perform(call: Call): Obs =
    val o = routes.get(call.name) match
      case Some((server, name)) => server.call(name, call.args)
      case None => if call.name == Symdex.spec.name then Symdex.setup(ws) else ws.perform(call)
    Main.nudged(call, o, symdex)

  def close(): Unit = servers.foreach(_.close())

object Project:
  val symdexNote: String = "For where something is defined or used, who calls it, what implements it, use " +
    "definition, references (callers=true), implementations, outline: exact, from the compiler; grep is for text."
