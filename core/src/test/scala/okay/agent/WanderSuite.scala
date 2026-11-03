package okay.agent

import okay.llm.Llm
import okay.scala3.*
import scala.util.Random

/** WANDER'S LAWS: the calls that run are the same with it as without (only what the model reads changes); after
 * twelve reads in a row the model is told, and not before */
class WanderSuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human)[X]
  private val laws = LawsSuite()
  private val tools = laws.tools

  test("the calls that run, the same with it as without — 200 runs of a hostile model"):
    for seed <- 1 to 200 do
      def go(p: Outcome ! Row => Outcome ! Row) =
        val r = Random(seed)
        run(Human.by(_ => "y")(Tools.recorded(laws.world)(Hypo.llm(laws.hostile(r))(
          p(Admit.within[Row, Outcome](tools)(Agent.run[Row](Agent.start("go", tools, Budget(turns = 30)))))))))._1
      assertEquals(go(Wander.nudging[Row, Outcome](tools, after = 3)(_)), go(identity), s"seed $seed")

  test("twelve reads in a row: the twelfth's observation says so; the eleventh's does not"):
    val script = Iterator.continually(Hypo.call("read", """{"path": "a"}""")).take(13) ++ Iterator("Not here.")
    val seen = Vector.newBuilder[String]
    run(Human.by(_ => "y")(Tools.by(_ => Obs("text"))(Hypo.llm(a => {
      seen ++= a.messages.lastOption.flatMap(_.field("content")).collect { case okay.effects.json.Json.Str(t) => t }
      script.next() })(Wander.nudging[Row, Outcome](tools)(Agent.run[Row](Agent.start("go", tools)))))))
    val obs = seen.result().drop(1)                // the first request's last message is the task
    assertEquals(obs.indexWhere(_.contains("12 reads and searches in a row")), 11)
    assert(!obs(10).contains("note:"))
