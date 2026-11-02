package okay.agent.cli

import java.nio.charset.StandardCharsets.UTF_8
import java.nio.file.{Files, Path, StandardCopyOption}
import java.util.concurrent.TimeUnit
import okay.effects.json.Json
import scala.jdk.CollectionConverters.*

/** SYMDEX INSTALLED AND KEPT UP TO DATE, with nothing to do: its manifest on GitHub Pages (`latest.json`: the version,
 * the release's zip, its SHA-256, the Java it needs) read at most once a day; a newer release downloaded, checked,
 * unpacked into ~/.symdex/<version> — where sbt-symdex puts it too, so the two share it. Offline, or told not to
 * (OKAY_AGENT_NO_INSTALL), what is installed is used. One on PATH is the owner's, never replaced. By curl, unzip and
 * shasum: the same on the JVM and Scala Native (which has no HTTPS of its own) */
final class SymdexInstall(home: Path = Path.of(sys.props("user.home"), ".symdex"),
    manifest: String = SymdexInstall.manifest, log: String => Unit = m => System.err.println(m),
    now: () => Long = () => System.currentTimeMillis()):
  private val checked = home.resolve(".checked")

  /** the newest installed under the home: (version, launcher) */
  def installed: Option[(String, Path)] =
    if !Files.isDirectory(home) then None
    else Files.list(home).iterator.asScala.toVector
      .map(d => d.getFileName.toString -> d.resolve("symdex/bin/symdex"))
      .filter((v, l) => v.headOption.exists(_.isDigit) && !v.endsWith(".part") && Files.exists(l))
      .sortBy((v, _) => SymdexInstall.version(v))(using Ordering.Tuple3[Int, Int, Int]).lastOption

  /** the launcher to use, by the stable path (~/.symdex/current, pointed at the newest installed): installed or
   * updated first when it is time */
  def ensure(): Option[String] =
    val have = installed
    // the last check's time, written in the file (by the same clock that asks)
    val last = try Files.readString(checked).trim.toLong catch case _: Exception => 0L
    val due = have.isEmpty || now() - last > SymdexInstall.day
    if !sys.env.contains("OKAY_AGENT_NO_INSTALL") && due then
      try latest().foreach(m => update(m, have))
      catch case e: Exception => log(s"symdex: not updated (${e.getMessage})")
      Files.createDirectories(home)
      Files.writeString(checked, now().toString)
    installed.map { (v, launcher) =>
      advance(v)
      val stable = home.resolve("current/symdex/bin/symdex")
      if Files.exists(stable) then stable.toString else launcher.toString
    }

  /** ~/.symdex/current pointed at `v` if it points at nothing, or at an older release: forward only (sbt-symdex does
   * the same) — the path projects' files name, so an update reaches them with the files unchanged */
  def advance(v: String): Unit =
    val current = home.resolve("current")
    val at = if Files.isSymbolicLink(current) then Some(Files.readSymbolicLink(current).getFileName.toString) else None
    if at.forall(a => SymdexInstall.newer(SymdexInstall.version(v), SymdexInstall.version(a)) || !Files.exists(current))
    then SymdexInstall.run(List("sh", "-c", s"cd '$home' && ln -sfn '$v' current"), 30)

  /** the manifest read */
  def latest(): Option[Json] =
    val (code, out) = SymdexInstall.run(List("curl", "-fsSL", "--max-time", "15", manifest), 30)
    if code != 0 then { log(s"symdex: the manifest not read ($manifest)"); None } else Some(Json.fromText(out))

  /** a newer release than the one installed: downloaded, checked, unpacked; its launcher */
  private def update(m: Json, have: Option[(String, Path)]): Option[Path] =
    val v = m("version").string
    if have.exists((h, _) => !SymdexInstall.newer(SymdexInstall.version(v), SymdexInstall.version(h))) then None
    else if !javaAtLeast(m.field("java").map(_.int).getOrElse(17)) then
      log(s"symdex $v needs Java ${m.field("java").map(_.int).getOrElse(17)}+: not installed"); None
    else
      val tmp = Files.createTempDirectory("symdex")
      val zip = tmp.resolve("symdex.zip")
      log(s"symdex: installing $v …")
      if SymdexInstall.run(List("curl", "-fsSL", "--max-time", "600", "-o", zip.toString, m("zip").string), 660)._1 != 0
      then { log("symdex: the download failed"); None }
      else
        val sum = SymdexInstall.run(List("shasum", "-a", "256", zip.toString), 60)._2.takeWhile(_ != ' ')
        if sum != m("sha256").string then { log(s"symdex: the download's SHA-256 is not the manifest's"); None }
        else
          val part = home.resolve(s"$v.part")
          SymdexInstall.run(List("rm", "-rf", part.toString), 60)
          Files.createDirectories(part)
          if SymdexInstall.run(List("unzip", "-q", zip.toString, "-d", part.toString), 300)._1 != 0 then
            log("symdex: the zip did not unpack"); None
          else
            // the release's zip carries no exec bit (sbt-symdex sets it too)
            SymdexInstall.run(List("sh", "-c", s"chmod +x '${part.resolve("symdex/bin")}'/*"), 30)
            val dest = home.resolve(v)
            SymdexInstall.run(List("rm", "-rf", dest.toString), 60)
            Files.move(part, dest, StandardCopyOption.ATOMIC_MOVE)
            log(s"symdex $v installed: $dest")
            Some(dest.resolve("symdex/bin/symdex"))

  private def javaAtLeast(major: Int): Boolean =
    val (code, out) = SymdexInstall.run(List("java", "-version"), 30)
    code == 0 && """version "(\d+)""".r.findFirstMatchIn(out).exists(_.group(1).toInt >= major)

object SymdexInstall:
  val manifest = "https://okay-effects.github.io/symdex/latest.json"
  private val day = 24L * 3600 * 1000

  def version(s: String): (Int, Int, Int) =
    val n = s.split('.').map(_.takeWhile(_.isDigit)).map(x => if x.isEmpty then 0 else x.toInt)
    (n.lift(0).getOrElse(0), n.lift(1).getOrElse(0), n.lift(2).getOrElse(0))

  /** whether `a` is a later release than `b` */
  def newer(a: (Int, Int, Int), b: (Int, Int, Int)): Boolean = Ordering.Tuple3[Int, Int, Int].gt(a, b)

  /** a command: its exit and its output (stderr with it) */
  def run(command: List[String], timeoutSeconds: Int): (Int, String) =
    val proc = ProcessBuilder(command.asJava).redirectErrorStream(true).start()
    val out = java.io.ByteArrayOutputStream()
    val drain: Runnable = () => { proc.getInputStream.transferTo(out); () }
    val t = Thread(drain)
    t.setDaemon(true)
    t.start()
    if !proc.waitFor(timeoutSeconds.toLong, TimeUnit.SECONDS) then { proc.destroyForcibly(); (-1, "timed out") }
    else { t.join(2000); (proc.exitValue(), out.toString(UTF_8)) }
