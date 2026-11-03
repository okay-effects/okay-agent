package okay.agent.cli

import java.nio.charset.StandardCharsets.UTF_8
import java.nio.file.{Files, Path}
import java.util.concurrent.TimeUnit
import okay.agent.{Call, Obs, ToolSpec}
import okay.effects.json.Json
import scala.jdk.CollectionConverters.*

/** THE TOOLS OF A WORKSPACE: files read, written and edited inside it alone (a path out of it refused), commands run
 * in it with a timeout, files found by glob and by a regex, the work committed. Outputs cut to what a local model's
 * window takes */
final class Workspace(val root: Path, timeoutSeconds: Int = 300, limit: Int = 20000):
  private val real = root.toRealPath()

  def perform(call: Call): Obs =
    try call.name match
      case "read" => read(arg(call, "path"), Workspace.line(call, "start_line"), Workspace.line(call, "end_line"))
      case "write" => write(arg(call, "path"), arg(call, "content"))
      case "edit" => edit(arg(call, "path"), arg(call, "old"), arg(call, "new"))
      case "bash" => bash(arg(call, "command"))
      case "glob" => glob(arg(call, "pattern"))
      case "grep" => grep(arg(call, "pattern"), call.args.field("glob").collect { case Json.Str(g) => g })
      case "git_commit" => commit(arg(call, "message"))
      case other => Obs(s"no tool '$other'", error = true)
    catch case e: Exception => Obs(Option(e.getMessage).getOrElse(e.toString), error = true)

  private def arg(c: Call, k: String): String = c.args.field(k) match
    case Some(Json.Str(s)) => s
    case _ => throw IllegalArgumentException(s"the argument '$k' is missing")

  /** a path of the workspace: relative to it, or absolute inside it; never out of it */
  def inside(p: String): Path =
    val target = (if Path.of(p).isAbsolute then Path.of(p) else real.resolve(p)).normalize()
    var existing = target
    while !Files.exists(existing) && existing.getParent != null do existing = existing.getParent
    val resolved = existing.toRealPath().resolve(existing.relativize(target)).normalize()
    if !resolved.startsWith(real) then throw IllegalArgumentException(s"'$p' is outside the project")
    resolved

  private def cut(s: String) = if s.length <= limit then s else s.take(limit) + s"\n… (${s.length - limit} more)"
  private def rel(p: Path) = real.relativize(p).toString

  private def read(p: String, from: Option[Int], to: Option[Int]) =
    val f = inside(p)
    if Files.isDirectory(f) then Obs(Files.list(f).iterator.asScala.map(x => rel(x) +
      (if Files.isDirectory(x) then "/" else "")).toVector.sorted.mkString("\n"))
    else Obs(Workspace.lines(Files.readString(f, UTF_8), from, to, limit))

  private def write(p: String, content: String) =
    val f = inside(p)
    Option(f.getParent).foreach(Files.createDirectories(_))
    Files.writeString(f, content, UTF_8)
    Obs(s"wrote ${rel(f)} (${content.linesIterator.size} lines)")

  private def edit(p: String, old: String, neu: String) =
    val f = inside(p)
    val text = Files.readString(f, UTF_8)
    val at = text.indexOf(old)
    if old.isEmpty then Obs("'old' is empty", error = true)
    else if at < 0 then Obs(s"'old' is not in ${rel(f)}: read it again, and copy the fragment exactly", error = true)
    else if text.indexOf(old, at + 1) >= 0 then
      Obs(s"'old' is in ${rel(f)} more than once: take more of it", error = true)
    else
      Files.writeString(f, text.substring(0, at) + neu + text.substring(at + old.length), UTF_8)
      Obs(s"edited ${rel(f)}")

  private def bash(command: String) = run(command, timeoutSeconds)

  /** a command in the workspace, with a timeout of its own */
  def run(command: String, timeoutSeconds: Int): Obs =
    val pb = ProcessBuilder("/bin/sh", "-c", command).directory(real.toFile).redirectErrorStream(true)
    val proc = pb.start()
    val out = java.io.ByteArrayOutputStream()
    val drain: Runnable = () => { proc.getInputStream.transferTo(out); () }
    val reader = Thread(drain)
    reader.setDaemon(true)
    reader.start()
    if !proc.waitFor(timeoutSeconds.toLong, TimeUnit.SECONDS) then
      proc.destroyForcibly()
      reader.join(1000)
      Obs(cut(out.toString(UTF_8)) + s"\n(stopped after ${timeoutSeconds}s)", error = true)
    else
      reader.join(2000)
      val code = proc.exitValue()
      Obs(cut(out.toString(UTF_8)) + (if code == 0 then "" else s"\n(exit $code)"), error = code != 0)

  /** the project's files: not the build's output, not a tool's own (target, node_modules, .git, .bsp …) */
  private def files: Vector[Path] =
    Files.walk(real).iterator.asScala.filter(Files.isRegularFile(_))
      .filterNot(p => real.relativize(p).iterator.asScala.exists(n => Workspace.skipped(n.toString))).toVector

  private def glob(pattern: String) =
    val re = Workspace.globRegex(pattern)
    val found = files.map(rel).filter(re.matches).sorted
    Obs(if found.isEmpty then "no file" else cut(found.mkString("\n")))

  private def grep(pattern: String, in: Option[String]) =
    val re = pattern.r
    val only = in.map(Workspace.globRegex)
    val hits = files.filter(p => only.forall(_.matches(rel(p)))).iterator.flatMap { p =>
      // text alone: a file with a NUL in its first KB is a binary's
      val head = try Files.newInputStream(p).readNBytes(1024) catch case _: Exception => Array.emptyByteArray
      val lines = if head.contains(0.toByte) then Nil
        else try Files.readAllLines(p, UTF_8).asScala catch case _: Exception => Nil
      lines.iterator.zipWithIndex.collect { case (l, i) if re.findFirstIn(l).isDefined => s"${rel(p)}:${i + 1}: $l" }
    }.take(200).toVector
    Obs(if hits.isEmpty then "no match" else cut(hits.mkString("\n")))

  private def commit(message: String) =
    val added = bash("git add -A")
    if added.error then added else bash(s"git commit -q -m ${Workspace.quote(message)} && git log --oneline -1")

object Workspace:
  /** directories the search tools pass over: build output and tools' own */
  def skipped(name: String): Boolean =
    name.startsWith(".git") || Set("target", "node_modules", ".bsp", ".idea", ".metals", ".bloop", "dist", "out",
      ".symdex")(name)

  /** a glob as a regex: `**` any depth, `*` within a name, `?` one character (RE2's syntax: Scala Native's too) */
  def globRegex(glob: String): scala.util.matching.Regex =
    val sb = new StringBuilder
    var i = 0
    while i < glob.length do
      glob(i) match
        case '*' if i + 1 < glob.length && glob(i + 1) == '*' =>
          if i + 2 < glob.length && glob(i + 2) == '/' then { sb ++= "(?:.*/)?"; i += 1 } else sb ++= ".*"
          i += 1
        case '*' => sb ++= "[^/]*"
        case '?' => sb ++= "[^/]"
        case c if "\\.[]{}()+^$|".contains(c) => sb += '\\'; sb += c
        case c => sb += c
      i += 1
    sb.toString.r

  def quote(s: String): String = "'" + s.replace("'", "'\\''") + "'"

  /** a line number a call gives (`start_line`, `end_line`): a number, or a number's text */
  def line(c: Call, k: String): Option[Int] = c.args.field(k).flatMap {
    case Json.Num(n) => Some(n.toInt)
    case Json.Str(t) => t.trim.toIntOption
    case _ => None
  }

  /** a file's text as `read` gives it: whole (cut to `limit`, the cut saying how to read on), or lines `from` to `to`
   * (1-based, inclusive, either end open) after a line saying which of how many */
  def lines(text: String, from: Option[Int], to: Option[Int], limit: Int): String =
    if from.isEmpty && to.isEmpty then
      if text.length <= limit then text
      else
        val shown = text.take(limit)
        val n = shown.count(_ == '\n') + 1
        s"$shown\n… (${text.length - limit} more characters: read on with start_line = $n)"
    else
      val all = text.split("\n", -1)
      val a = from.getOrElse(1).max(1)
      val b = to.getOrElse(all.length).min(all.length)
      if a > all.length then s"(the file has ${all.length} lines)"
      else
        val body = all.slice(a - 1, b).mkString("\n")
        val cutBody = if body.length <= limit then body else body.take(limit) + "\n…"
        s"(lines $a–$b of ${all.length})\n$cutBody"

  private def obj(props: (String, String, String)*) = Json.obj("type" -> Json.Str("object"),
    "properties" -> Json.Obj(props.toVector.map((n, d, _) => n -> Json.obj("type" -> Json.Str("string"),
      "description" -> Json.Str(d)))),
    "required" -> Json.Arr(props.toVector.filter(_._3 == "required").map(p => Json.Str(p._1))))

  /** the tools offered: short descriptions (a local model reads them each session) */
  val tools: Vector[ToolSpec] = Vector(
    ToolSpec("read", "Read a file (or list a directory); a long one in parts: start_line, end_line.",
      Json.obj("type" -> Json.Str("object"), "properties" -> Json.obj(
        "path" -> Json.obj("type" -> Json.Str("string"), "description" -> Json.Str("relative path")),
        "start_line" -> Json.obj("type" -> Json.Str("integer"), "description" -> Json.Str("first line, 1-based")),
        "end_line" -> Json.obj("type" -> Json.Str("integer"), "description" -> Json.Str("last line, inclusive"))),
        "required" -> Json.arr(Json.Str("path"))),
      ToolSpec.Kind.Read),
    ToolSpec("write", "Write a whole file (created if missing).",
      obj(("path", "relative path", "required"), ("content", "the file's text", "required")), ToolSpec.Kind.Write),
    ToolSpec("edit", "Replace one exact fragment of a file with another.", obj(("path", "relative path", "required"),
      ("old", "the exact text to replace, once in the file", "required"), ("new", "its replacement", "required")),
      ToolSpec.Kind.Write),
    ToolSpec("bash", "Run a shell command in the project directory.", obj(("command", "the command", "required")),
      ToolSpec.Kind.Exec),
    ToolSpec("glob", "Find files by a glob, e.g. **/*.scala.", obj(("pattern", "the glob", "required")),
      ToolSpec.Kind.Read),
    ToolSpec("grep", "Search files for a regex.", obj(("pattern", "the regex", "required"),
      ("glob", "only files matching this glob", "optional")), ToolSpec.Kind.Read),
    ToolSpec("git_commit", "Commit all changes with a message.", obj(("message", "the commit message", "required")),
      ToolSpec.Kind.Irreversible))
