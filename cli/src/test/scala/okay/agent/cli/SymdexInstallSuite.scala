package okay.agent.cli

import java.nio.file.{Files, Path}

/** symdex installed from a manifest and kept up to date: a release made here (a zip, its manifest by file://) */
class SymdexInstallSuite extends munit.FunSuite:
  /** a release of `version`: its zip (symdex/bin/symdex, no exec bit) and a manifest; `sha` the one it states */
  private def release(dir: Path, version: String, sha: Option[String] = None): Path =
    val src = Files.createTempDirectory("rel")
    Files.createDirectories(src.resolve("symdex/bin"))
    Files.writeString(src.resolve("symdex/bin/symdex"), s"#!/bin/sh\necho symdex $version\n")
    val zip = dir.resolve(s"symdex-$version.zip")
    SymdexInstall.run(List("sh", "-c", s"cd '$src' && zip -qr '$zip' symdex"), 60)
    val sum = SymdexInstall.run(List("shasum", "-a", "256", zip.toString), 60)._2.takeWhile(_ != ' ')
    val manifest = dir.resolve("latest.json")
    Files.writeString(manifest, s"""{"version": "$version", "zip": "file://$zip", "sha256": "${sha.getOrElse(sum)}",
      "java": 11}""")
    manifest

  test("installed from the manifest; checked once a day; a newer release installed; a wrong SHA-256 refused"):
    val dir = Files.createTempDirectory("pages")
    val home = Files.createTempDirectory("home").resolve(".symdex")
    var clock = 1_000_000L
    val said = Vector.newBuilder[String]
    def installer = SymdexInstall(home, "file://" + release(dir, "0.6.0"), said += _, () => clock)
    val first = installer.ensure()
    assertEquals(first, Some(home.resolve("current/symdex/bin/symdex").toString))
    assertEquals(java.nio.file.Files.readSymbolicLink(home.resolve("current")).toString, "0.6.0")
    assertEquals(SymdexInstall.run(List(first.get), 30)._2.trim, "symdex 0.6.0")   // the exec bit set
    // a newer release, but checked an hour ago: not looked at yet
    release(dir, "0.7.0")
    clock += 3600 * 1000L
    assertEquals(SymdexInstall(home, "file://" + dir.resolve("latest.json"), said += _, () => clock).ensure(), first)
    // a day later: the newer one installed, the newest used
    clock += 24 * 3600 * 1000L
    val second = SymdexInstall(home, "file://" + dir.resolve("latest.json"), said += _, () => clock).ensure()
    assertEquals(second, Some(home.resolve("current/symdex/bin/symdex").toString))
    assertEquals(SymdexInstall.run(List(second.get), 30)._2.trim, "symdex 0.7.0")
    // a release whose zip is not the one its manifest states: refused, the installed one kept
    release(dir, "0.8.0", sha = Some("0" * 64))
    clock += 2 * 24 * 3600 * 1000L
    assertEquals(SymdexInstall(home, "file://" + dir.resolve("latest.json"), said += _, () => clock).ensure(), second)
    assert(said.result().exists(_.contains("SHA-256")), said.result().toString)
    // the stable path: current at the newest, forward only
    assertEquals(java.nio.file.Files.readSymbolicLink(home.resolve("current")).toString, "0.7.0")

  test("offline: what is installed is used"):
    val home = Files.createTempDirectory("home").resolve(".symdex")
    val dir = Files.createTempDirectory("pages")
    SymdexInstall(home, "file://" + release(dir, "0.6.0"), _ => ()).ensure()
    val later = () => System.currentTimeMillis() + 9e9.toLong
    val offline = SymdexInstall(home, "file:///nowhere/latest.json", _ => (), later)
    assertEquals(offline.ensure(), Some(home.resolve("current/symdex/bin/symdex").toString))
