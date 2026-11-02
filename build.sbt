// okay-agent: a coding agent as one program over effects — the model (okay-llm's Llm), its tools, a person — every
// world handlers, every guarantee an interceptor with its law. Local models first (okay-mlx). JVM and Scala Native
import sbtcrossproject.CrossPlugin.autoImport.{crossProject, CrossType}

ThisBuild / scalaVersion := "3.3.8"
ThisBuild / organization := "io.github.okay-effects"
ThisBuild / version := "0.1.0-SNAPSHOT"
ThisBuild / scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked", "-Wunused:imports,privates,locals")
ThisBuild / resolvers ++= Seq("okay-llm" at "https://okay-effects.github.io/okay-llm/maven",
  "okay-scala" at "https://okay-effects.github.io/okay-scala/maven",
  "okay-simple" at "https://okay-effects.github.io/okay-simple/maven")
ThisBuild / licenses := List("Apache-2.0" -> url("https://www.apache.org/licenses/LICENSE-2.0.txt"))
ThisBuild / homepage := Some(url("https://github.com/okay-effects/okay-agent"))

val okayLlm = "0.1.0"
val munit = Def.setting("org.scalameta" %%% "munit" % "1.2.3" % Test)

/** THE AGENT: the program, its effects, its interceptors, the hypothesis — no I/O */
lazy val core = crossProject(JVMPlatform, NativePlatform).crossType(CrossType.Pure).in(file("core"))
  .settings(name := "okay-agent",
    libraryDependencies ++= Seq("io.github.okay-effects" %%% "okay-llm" % okayLlm, munit.value))

/** THE CLI: the agent in a workspace — its local tools, the terminal its person, the model over HTTP */
lazy val cli = crossProject(JVMPlatform, NativePlatform).crossType(CrossType.Pure).in(file("cli")).dependsOn(core)
  .settings(name := "okay-agent-cli", libraryDependencies += munit.value)
  .jvmSettings(run / fork := true, run / connectInput := true, Test / fork := true)

lazy val root = (project in file(".")).aggregate(
  (core.componentProjects ++ cli.componentProjects).map(p => p: ProjectReference): _*).settings(publish / skip := true)
