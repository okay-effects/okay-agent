package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Llm}
import okay.scala3.*
import scala.util.Random

/** THE LAWS, over states reached by real transitions: the program run on a hypothesis's random answers — never a
 * state made by hand. Each law over many runs */
class LawsSuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human)[X]
  private def obj(props: (String, String)*) = Json.obj("type" -> Json.Str("object"),
    "properties" -> Json.Obj(props.toVector.map((n, t) => n -> Json.obj("type" -> Json.Str(t)))),
    "required" -> Json.Arr(props.toVector.map(p => Json.Str(p._1))))
  val tools = Vector(
    ToolSpec("read", "Read a file", obj("path" -> "string"), ToolSpec.Kind.Read),
    ToolSpec("write", "Write a file", obj("path" -> "string", "content" -> "string"), ToolSpec.Kind.Write),
    ToolSpec("bash", "Run a command", obj("command" -> "string"), ToolSpec.Kind.Exec))
  private val runs = 300

  /** a hostile model: calls offered tools and others, its arguments right, missing, or of the wrong type; done at
   * random */
  def hostile(r: Random)(ask: Ask): String =
    if r.nextDouble() < 0.15 then "Done."
    else
      val name = Vector("read", "write", "bash", "rm_rf", "commit", "Read")(r.nextInt(6))
      val args = Vector("""{"path": "a.txt"}""", """{"path": "a.txt", "content": "x"}""", """{"command": "ls"}""",
        """{}""", """{"path": 7}""", """{"command": ["ls"]}""", """"not an object"""")(r.nextInt(7))
      Hypo.call(name, args)

  def world(c: Call) = Obs(s"ok ${c.name}")

  test("admit: no call reaches the world unless its tool was offered and its arguments fit — under a hostile model"):
    var made = 0
    var reached = 0
    for seed <- 1 to runs do
      val r = Random(seed)
      val (performed, _) = run(Human.by(_ => "y")(Tools.recorded(world)(Hypo.llm(a => {
        val t = hostile(r)(a); if t.contains("tool_call") then made += 1; t })(
        Admit.within(tools)(Agent.run[Row](Agent.start("go", tools, Budget(turns = 12))))))))
      reached += performed.size
      performed.foreach(c => assertEquals(Admit.refusal(tools, c), None, s"seed $seed: $c reached the world"))
    // not vacuous: many calls made, some admitted, most not
    assert(reached > 0 && reached < made / 2, s"$reached of $made calls reached the world")

  test("termination: a model that never stops is stopped by the budget, at it"):
    for seed <- 1 to runs do
      val turns = 1 + Random(seed).nextInt(30)
      val outcome = run(Human.by(_ => "y")(Tools.by(world)(Hypo.llm(_ => Hypo.call("read", """{"path": "a"}"""))(
        Agent.run[Row](Agent.start("go", tools, Budget(turns = turns)))))))
      assertEquals(outcome, Outcome.OutOfBudget(s"$turns turns"))

  test("the prefix law: each request is the last one with turns appended, nothing before them changed"):
    for seed <- 1 to runs do
      val r = Random(seed)
      val asks = Vector.newBuilder[Ask]
      run(Human.by(_ => "y")(Tools.by(world)(Hypo.llm(a => { asks += a; hostile(r)(a) })(
        Admit.within(tools)(Agent.run[Row](Agent.start("go", tools, Budget(turns = 12))))))))
      asks.result().map(_.messages).sliding(2).foreach {
        case Seq(a, b) => assertEquals(b.take(a.length), a, s"seed $seed: a request changed what came before")
        case _ => ()
      }

  test("the gate: a call of a kind asked about goes on a yes; on a no the model observes it, the world never sees it"):
    val answers = Iterator("y", "no, not that file")
    val script = Iterator(Hypo.call("write", """{"path": "a", "content": "1"}"""),
      Hypo.call("write", """{"path": "b", "content": "2"}"""), Hypo.call("read", """{"path": "a"}"""), "Done.")
    val seen = Vector.newBuilder[String]
    val (performed, outcome) = run(Human.by(_ => answers.next())(Tools.recorded(world)(Hypo.llm(a => {
      seen ++= a.messages.lastOption.flatMap(_.field("content")).collect { case Json.Str(t) => t }
      script.next() })(Gate.asking(tools, _ != ToolSpec.Kind.Read)(Agent.run[Row](Agent.start("go", tools)))))))
    assertEquals(performed.map(c => (c.name, c.args("path").string)), Vector(("write", "a"), ("read", "a")))
    assertEquals(outcome, Outcome.Done("Done."))
    assert(seen.result().exists(_.contains("did not allow it: no, not that file")))

/** REPLAY'S LAW: a run replayed from its journal — no model, no world — does the same acts and ends the same */
class ReplaySuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human + Journal)[X]
  type Replayed[X] = (Llm + Tools + Journal)[X]
  private val laws = LawsSuite()
  private def acts(es: Vector[Json]) = es.filter(_("k").string == "act")

  test("replayed from its journal: the same acts, the same end — under a hostile model, admitted"):
    for seed <- 1 to 200 do
      val r = scala.util.Random(seed)
      val ctx = Agent.start("go", laws.tools, Budget(turns = 10))
      val (entries, outcome) = run(Journal.collect(Human.by(_ => "y")(Tools.by(laws.world)(
        Hypo.llm(laws.hostile(r))(Journal.recording[Row, Outcome](
          Admit.within[Row, Outcome](laws.tools)(Agent.run[Row](ctx))))))))
      val (again, outcomeAgain) = run(Journal.collect(Replay.from(entries)(Journal.recording[Replayed, Outcome](
        Admit.within[Replayed, Outcome](laws.tools)(Agent.run[Replayed](ctx))))))
      assertEquals(outcomeAgain, outcome, s"seed $seed")
      assertEquals(acts(again), acts(entries), s"seed $seed")
      assert(!acts(again).exists(_("obs").string.contains("diverged")), s"seed $seed: diverged")
