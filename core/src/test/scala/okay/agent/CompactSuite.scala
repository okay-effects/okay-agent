package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Llm}
import okay.scala3.*
import scala.util.Random

/** COMPACTION'S LAW: invisible in what the agent does. A hypothesis that acts on what it sees: told "write n files",
 * it writes the next after the last observed — compaction keeping the latest turns, its acts the same as without it;
 * one losing them (the negative control), not. And between compactions, the requests still only append */
class CompactSuite extends munit.FunSuite:
  type Row[X] = (Llm + Tools + Human)[X]
  private val tools = Vector(ToolSpec("write", "Write a file", Json.obj("type" -> Json.Str("object"),
    "properties" -> Json.obj("path" -> Json.obj("type" -> Json.Str("string"))),
    "required" -> Json.arr(Json.Str("path"))), ToolSpec.Kind.Write))

  private def text(m: Json) = m.field("content").collect { case Json.Str(t) => t }.getOrElse("")

  /** acts on what it sees: the summary answered when asked for one; else the file after the last one written */
  private def focused(n: Int)(ask: Ask): String =
    if text(ask.messages.head) == Compact.Summarizer then "Wrote some files; more to write."
    else
      val done = ask.messages.reverse.collectFirst { case m if text(m).startsWith("wrote f") =>
        text(m).stripPrefix("wrote f").toInt }
      done match
        case Some(k) if k >= n => "All written."
        case Some(k) => Hypo.call("write", s"""{"path": "f${k + 1}"}""") + (" padding" * 20)
        case None => Hypo.call("write", """{"path": "f1"}""")

  private def world(c: Call) = Obs(s"wrote ${c.args("path").string}")

  private def acts(n: Int, compacting: Option[Compact.Window], asks: Ask => Unit = _ => ()) =
    def agent = Agent.run[Row](Agent.start(s"write f1 to f$n", tools, Budget(turns = n + 5)))
    val program = compacting.fold(agent)(w => Compact.within[Row, Outcome](w)(agent))
    run(Human.by(_ => "y")(Tools.recorded(world)(Hypo.llm(a => { asks(a); focused(n)(a) })(program))))

  test("invisible in what the agent does: the same acts with it and without it — and it happened"):
    var compactions = 0
    for seed <- 1 to 200 do
      val r = Random(seed)
      val n = 5 + r.nextInt(30)
      val window = Compact.Window(tokens = 300 + r.nextInt(300))
      val plain = acts(n, None)
      val compacted = acts(n, Some(window), a => if text(a.messages.head) == Compact.Summarizer then compactions += 1)
      assertEquals(compacted, plain, s"seed $seed: compaction changed what the agent did")
    assert(compactions > 200, s"only $compactions compactions: the law tested on nothing")

  test("the negative control: a compaction that loses the latest turns is caught"):
    // keep nothing, not even the latest turn: the model sees the summary alone, not the file it wrote last
    val lossy = Compact.Window(tokens = 400, keep = 0.0, keepLatest = false)
    val violations = (5 to 25).count(n => acts(n, Some(lossy)) != acts(n, None))
    assert(violations > 10, s"$violations of 21: the law did not tell a lossy compaction apart")

  test("between compactions the requests still only append; a break only where it compacted"):
    for seed <- 1 to 100 do
      val r = Random(seed)
      val n = 10 + r.nextInt(20)
      val seen = Vector.newBuilder[Vector[Json]]
      var compactions = 0
      acts(n, Some(Compact.Window(tokens = 300 + r.nextInt(300))), a =>
        if text(a.messages.head) == Compact.Summarizer then compactions += 1 else seen += a.messages)
      val breaks = seen.result().sliding(2).count { case Seq(a, b) => b.take(a.length) != a; case _ => false }
      assertEquals(breaks, compactions, s"seed $seed")
