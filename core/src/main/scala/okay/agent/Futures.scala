package okay.agent

import okay.llm.Llm
import okay.scala3.*
import okay.scala3.std.Cofree

/** THE FORECAST AS A TREE: what may follow a call, branching where the world may answer either way — a command (or
 * a commit) passing or failing. Each node a point of the conversation: the calls of a turn, what was assumed of the
 * first command of the turn before it, how it ended there if it did; each child one turn of the real model further
 * (its requests extend the conversation: the cache shared). Made breadth first within a budget of nodes (each a
 * model's turn); okay-scala's `Cofree`, so "how risky is everything below this point" is `extend` */
object Futures:
  /** a point ahead: the conversation (up to a turn whose calls are not answered yet, or ended), those calls, what
   * was assumed of the turn's command before it ("" at the root, "passed", "failed"), the end if it ended there */
  final case class Ahead(ctx: Ctx, calls: Vector[Call], assumed: String, ended: Option[Outcome], turns: Int)

  /** the tree from the call `now` (its turn's `rest` after it): the calls imagined done but the turn's first command,
   * which branches; `budget` nodes at most, `horizon` turns deep at most */
  def of[R[_]: Has[Llm]](ctx: Ctx, now: Call, rest: Vector[Call], tools: Vector[ToolSpec], horizon: Int,
      budget: Int, imagine: Call => Obs): Cofree[Ahead] ! R =
    def kind(c: Call) = tools.find(_.name == c.name).map(_.kind).getOrElse(ToolSpec.Kind.Exec)
    def branches(calls: Vector[Call]): Option[Call] =
      calls.find(c => kind(c) == ToolSpec.Kind.Exec || kind(c) == ToolSpec.Kind.Irreversible)
    // the model's turns spent: one a node, the root's none — never past the budget
    var spent = 0
    def next(n: Ahead): List[Ahead] ! R =
      if n.ended.isDefined || n.turns >= horizon || n.calls.isEmpty then pure(Nil)
      else
        val b = branches(n.calls)
        val variants = (if b.isDefined then List("passed", "failed") else List("")).take((budget - 1 - spent).max(0))
        spent += variants.size
        each(variants) { v =>
          val obs = n.calls.map(c => Agent.observation(c,
            if b.contains(c) then (if v == "failed" then Obs("(forecast) it failed", error = true)
              else Obs("(forecast) it went through")) else imagine(c)))
          val seen = n.ctx.copy(messages = n.ctx.messages ++ obs)
          Llm.complete[R](seen.ask).map { f =>
            val calls = Agent.callsOf(f, 1000 + n.turns + 1)
            val ctx = seen.copy(messages = seen.messages :+ Agent.turn(f, calls))
            Ahead(ctx, calls, v, Option.when(calls.isEmpty)(Outcome.Done(f.reply.content)), n.turns + 1)
          }
        }
    Cofree.unfold[Ahead, R](Ahead(ctx, now +: rest, "", None, 0), budget)(next)

  private def each[A, B, R[_]](as: List[A])(f: A => B ! R): List[B] ! R =
    as.foldLeft(pure[List[B], R](Nil))((acc, a) => acc.flatMap(bs => f(a).map(bs :+ _)))

  /** the risky acts below a point — at every point of a tree by `extend` */
  def below(tools: Vector[ToolSpec])(t: Cofree[Ahead]): List[(Call, String)] =
    t.tail.flatMap(_.all).flatMap(_.calls).flatMap(c => Forecast.danger(tools)(c).map(c -> _))

  /** the acts ahead of the call decided: the rest of its turn (the root's calls but the first), then below */
  def ahead(t: Cofree[Ahead]): Vector[Call] = (t.head.calls.drop(1) ++ t.tail.flatMap(_.all).flatMap(_.calls))

  /** the risky acts ahead of the call decided */
  def risks(tools: Vector[ToolSpec])(t: Cofree[Ahead]): List[(Call, String)] =
    ahead(t).toList.flatMap(c => Forecast.danger(tools)(c).map(c -> _))

  /** a line for a person: how many futures were seen, in how many something risky comes, which */
  def summary(tools: Vector[ToolSpec])(t: Cofree[Ahead]): String =
    val now = t.head.calls.drop(1)
    val paths = t.paths.map(_.drop(1))
    def danger(c: Call) = Forecast.danger(tools)(c).isDefined
    val risky = paths.filter(p => now.exists(danger) || p.exists(_.calls.exists(danger)))
    val what = risks(tools)(t).map((c, why) => s"${Forecast.brief(c)} ($why)").distinct
    val branched = paths.map(_.map(_.assumed).filter(_.nonEmpty).mkString(", ")).filter(_.nonEmpty)
    s"futures: ${paths.size} seen (${t.size - 1} turns ahead${
      if branched.isEmpty then "" else s"; as commands pass or fail"})" +
      (if risky.isEmpty then "; nothing risky in any"
      else s"; ⚠ in ${risky.size} of ${paths.size}: ${what.mkString(", ")}")
