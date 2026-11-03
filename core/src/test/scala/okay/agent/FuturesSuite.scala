package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Llm}
import okay.scala3.*
import scala.util.Random

/** THE TREE OF FUTURES: one path where nothing branches (the single forecast's acts); a branch at every command, as
 * it passes or fails; within its budget; touching nothing; the risk below each point by extend */
class FuturesSuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human)[X]
  private val laws = LawsSuite()
  private val tools = laws.tools :+ ToolSpec("git_commit", "Commit", Json.obj("type" -> Json.Str("object")),
    ToolSpec.Kind.Irreversible)
  private val imagine: Call => Obs = c => Obs(s"(imagined) ${c.name} done")
  private def ctxAt(): Ctx = Agent.start("go", tools)
  private val now = Call("call_0_0", "write", Json.obj("path" -> Json.Str("a"), "content" -> Json.Str("x")))
  private def turnOf(call: Call): Json = Json.obj("role" -> Json.Str("assistant"), "content" -> Json.Str(""),
    "tool_calls" -> Json.arr(Json.obj("id" -> Json.Str(call.id), "type" -> Json.Str("function"),
      "function" -> Json.obj("name" -> Json.Str(call.name), "arguments" -> call.args))))
  private def start = ctxAt().copy(messages = ctxAt().messages :+ turnOf(now))
  private def tree(model: Ask => String, budget: Int, horizon: Int = 4) =
    run(Hypo.llm(model)(Futures.of[[X] =>> Llm[X]](start, now, Vector.empty, tools, horizon, budget, imagine)))

  /** what the conversation's last observation says, as the model reads it */
  private def last(a: Ask) = a.messages.lastOption.flatMap(_.field("content")).collect { case Json.Str(t) => t }
    .getOrElse("")

  test("no command ahead: one path, the single forecast's acts"):
    val script: Ask => String = a => a.messages.count(_.field("tool_calls").isDefined) match
      case 1 => Hypo.call("read", """{"path": "a"}""")
      case 2 => Hypo.call("write", """{"path": "b", "content": "y"}""")
      case _ => "Done."
    val t = tree(script, 10)
    assertEquals(t.paths.size, 1)
    val single = run(Hypo.llm(script)(Forecast.of[[X] =>> Llm[X]](start, now, Vector.empty, tools, 4, imagine)))
    assertEquals(Futures.ahead(t).map(_.name), single.acts.map(_.name))

  test("a command branches as it passes or fails; each branch the model's own; the risk below each point by extend"):
    // a test after the edit; it passing: commit; it failing: fix and stop
    def committed(a: Ask) = a.messages.exists(_.render.contains("git_commit"))
    val script: Ask => String = a =>
      if committed(a) then "Done."
      else if last(a).contains("it went through") then Hypo.call("git_commit", """{"message": "x"}""")
      else if last(a).contains("it failed") then Hypo.call("write", """{"path": "a", "content": "fixed"}""")
      else if a.messages.count(_.field("tool_calls").isDefined) == 1 then
        Hypo.call("bash", """{"command": "sbt test"}""")
      else "Done."
    val t = tree(script, 10)
    val ends = t.paths.map(_.drop(1).map(n => (n.assumed, n.calls.map(_.name).mkString)))
    assert(ends.exists(_.exists(_ == ("passed", "git_commit"))), ends.toString)
    assert(ends.exists(_.exists(_ == ("failed", "write"))), ends.toString)
    // the commit (passing or not), or the fix: three futures, two with the commit
    assertEquals(t.paths.size, 3)
    assert(Futures.summary(tools)(t).contains("⚠ in 2 of 3: git_commit x (not to be undone)"),
      Futures.summary(tools)(t))
    // extend: at each node the risk below it; the root's the whole tree's
    val risk = t.extend(Futures.below(tools)(_).size)
    assertEquals(risk.head, Futures.below(tools)(t).size)
    assertEquals(risk.all.max, risk.head)

  test("within its budget: a model's turn a node at most"):
    var asked = 0
    val always: Ask => String = _ => { asked += 1; Hypo.call("bash", """{"command": "ls"}""") }
    val t = tree(always, 7, horizon = 10)
    assertEquals(t.size, 7)
    assertEquals(asked, 6)

  test("the gate on a tree touches nothing: the world's acts the same with it as without — 100 runs"):
    def model(seed: Int)(a: Ask): String = laws.hostile(Random(seed * 31 + Json.Arr(a.messages).render.hashCode))(a)
    for seed <- 1 to 100 do
      val start = Agent.start("go", tools, Budget(turns = 8))
      val (without, end) = run(Human.by(_ => "y")(Tools.recorded(laws.world)(Hypo.llm(model(seed))(
        Admit.within[Row, Outcome](tools)(Agent.run[Row](start))))))
      val (withIt, endWith) = run(Human.by(_ => "y")(Tools.recorded(laws.world)(Hypo.llm(model(seed))(
        Forecast.gate[Row, Outcome](tools, 3, imagine, Some((_, _, _) => true), futures = 5)(
          Admit.within[Row, Outcome](tools)(Agent.run[Row](start)))))))
      assertEquals(withIt, without, s"seed $seed")
      assertEquals(endWith, end, s"seed $seed")
