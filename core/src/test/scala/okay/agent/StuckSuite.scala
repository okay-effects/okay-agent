package okay.agent

import okay.llm.Llm
import okay.scala3.*
import scala.util.Random

/** STUCK'S LAWS: after three failures in a row no call but a read reaches the world unless the person said yes to it —
 * under a hostile model and a world that fails at random; and with no failures nobody is asked */
class StuckSuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human)[X]
  private val laws = LawsSuite()
  private val tools = laws.tools

  /** one run: the world's calls, each with the failures in a row behind it (as the agent saw them), and the yeses */
  def session(seed: Int, failing: Double): (Vector[(Call, Int)], Int, Int) =
    val r = Random(seed)
    var seen = Vector.empty[Boolean]            // every observation's failure, in order (a person's refusal: none)
    var world = Vector.empty[(Call, Int)]
    var yes = 0
    var asked = 0
    var lastAnswer: Option[(String, Boolean)] = None   // the last question, and whether it was a yes
    def streak = seen.reverseIterator.takeWhile(identity).size
    // innermost: sees each call first and its answer last — the admit's and stuck's refusals too
    def watched(p: Outcome ! Row): Outcome ! Row = around[Tools, Row, Outcome](p)(
      [X] => (op: Tools[X], proceed: X ! Row) => op match
        case Tools.Perform(_) => proceed.map { o => seen :+= o.error && !o.refused; o })
    // stuck inside admit (it sees a call first, and admit's refusals as failures), as the CLI has it
    val program = Admit.within[Row, Outcome](tools)(Stuck.asking[Row, Outcome](tools)(
      watched(Agent.run[Row](Agent.start("go", tools, Budget(turns = 25))))))
    run(Human.by { q =>
      asked += 1
      val y = r.nextBoolean()
      if y then yes += 1
      lastAnswer = Some((q, y))
      if y then "y" else "no"
    }(Tools.by { c =>
      if streak >= 3 && c.name != "read" then
        assert(lastAnswer.exists((q, y) => y && q.contains(s"${c.name} ${c.args.render}")),
          s"seed $seed: ${c.name} went on stuck, the last answer $lastAnswer")
      lastAnswer = None
      world :+= ((c, streak))
      Obs(s"ran ${c.name}", error = r.nextDouble() < failing)
    }(okay.agent.Hypo.llm(laws.hostile(r))(program))))
    (world, yes, asked)

  test("no call but a read reaches the world after three failures in a row, unless the person said yes — 300 runs"):
    var asked = 0
    var yeses = 0
    for seed <- 1 to 300 do
      val (world, yes, a) = session(seed, failing = 0.5)
      // each call that went on stuck was the one a yes was just given for (asserted in the world); never more
      val past = world.count((c, streak) => streak >= 3 && c.name != "read")
      assert(past <= yes, s"seed $seed: $past calls went on stuck, $yes yeses")
      asked += a
      yeses += yes
    // not vacuous: asked often, both answers given
    assert(asked > 100 && yeses > 30 && yeses < asked, s"$asked asked, $yeses yes")

  test("a world that never fails and calls that fit: nobody asked"):
    val script = Iterator.continually(Iterator(Hypo.call("write", """{"path": "a", "content": "x"}"""),
      Hypo.call("bash", """{"command": "ls"}"""))).flatten.take(12) ++ Iterator("Done.")
    var asked = 0
    val outcome = run(Human.by(_ => { asked += 1; "y" })(Tools.by(c => Obs("ok"))(Hypo.llm(_ => script.next())(
      Stuck.asking[Row, Outcome](tools)(Agent.run[Row](Agent.start("go", tools)))))))
    assertEquals(outcome, Outcome.Done("Done."))
    assertEquals(asked, 0)

  test("replayed from a journal kept innermost: the same acts and end, the gate's, stuck's and admit's refusals in it"):
    type J[X] = (Llm + Tools + Human + Journal)[X]
    type Replayed[X] = (Llm + Tools + Journal)[X]
    def acts(es: Vector[okay.effects.json.Json]) = es.filter(_("k").string == "act")
    var refusals = 0
    for seed <- 1 to 200 do
      val r = Random(seed)
      val ctx = Agent.start("go", tools, Budget(turns = 20))
      val (entries, end) = run(Journal.collect(Human.by(_ => if r.nextBoolean() then "y" else "no")(Tools.by(c =>
        Obs(s"ran ${c.name}", error = r.nextDouble() < 0.5))(okay.agent.Hypo.llm(laws.hostile(r))(
        Gate.asking[J, Outcome](tools, _ == ToolSpec.Kind.Exec)(Admit.within[J, Outcome](tools)(
          Stuck.asking[J, Outcome](tools)(Journal.recording[J, Outcome](Agent.run[J](ctx))))))))))
      val (again, endAgain) = run(Journal.collect(Replay.from(entries)(
        Journal.recording[Replayed, Outcome](Agent.run[Replayed](ctx)))))
      assertEquals(endAgain, end, s"seed $seed")
      assertEquals(acts(again), acts(entries), s"seed $seed")
      refusals += acts(entries).count(a => a("obs").string.contains("did not allow") ||
        a("obs").string.contains("stopped it"))
    assert(refusals > 50, s"$refusals refusals in the journals")

  test("a person's refusals are not the agent's failures: three no's from the gate, no fourth question"):
    val script = Iterator.continually(Hypo.call("bash", """{"command": "./build.sh"}""")).take(5) ++ Iterator("Done.")
    val questions = Vector.newBuilder[String]
    run(Human.by(q => { questions += q; "no" })(Tools.by(_ => Obs("ran"))(Hypo.llm(_ => script.next())(
      Gate.asking[Row, Outcome](tools, _ == ToolSpec.Kind.Exec)(Stuck.asking[Row, Outcome](tools)(
        Agent.run[Row](Agent.start("go", tools))))))))
    assert(questions.result().forall(_.contains("allow?")), questions.result().toString)
    assertEquals(questions.result().size, 5)

