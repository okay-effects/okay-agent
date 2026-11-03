package okay.agent

import okay.scala3.*
import okay.scala3.std.{Coeffects, History}

/** STUCK: a coeffect — a call decided by the history behind it. After `after` calls failed in a row, a call that is
 * not a read is put to the person first; a no is the model's observation. Reads go on: looking is how an agent gets
 * unstuck (specs/agent.md, interceptor 8) */
object Stuck:
  /** a call as the history keeps it: its tool, whether it failed (none while it runs) */
  final case class Seen(name: String, failed: Option[Boolean])

  /** the calls just before the focus that failed, one after another */
  def failedInRow(h: History[Seen]): Int = h.past.reverseIterator.takeWhile(_.failed.contains(true)).size

  def asking[R[_], A](tools: Vector[ToolSpec], after: Int = 3)(p: A ! R)(using In[Tools, R], In[Human, R]): A ! R =
    if after <= 0 then p
    else Coeffects.aroundHistory[Tools, Seen, R, A](p)(
      [X] => (op: Tools[X]) => op match { case Tools.Perform(c) => Seen(c.name, None) },
      // a failure the agent's: an error no person chose (a refusal by the gate, the forecast, stuck: not counted)
      [X] => (op: Tools[X], x: X) => op match
        case Tools.Perform(c) => Seen(c.name, Some(x.error && !x.refused)))(
      [X] => (h: History[Seen], op: Tools[X], proceed: X ! R) => op match
        case Tools.Perform(call)
            if failedInRow(h) >= after && !tools.find(_.name == call.name).exists(_.kind == ToolSpec.Kind.Read) =>
          Human.ask[R](s"${failedInRow(h)} calls failed in a row — go on with ${call.name} ${call.args.render}? " +
            "[y/N] ").flatMap(a => if a.trim.toLowerCase.startsWith("y") then proceed
            else pure(Obs(s"the person stopped it after ${failedInRow(h)} failed calls" +
              (if a.trim.isEmpty then "" else s": $a"), error = true, refused = true)))
        case _ => proceed)
