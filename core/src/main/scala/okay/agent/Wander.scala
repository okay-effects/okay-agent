package okay.agent

import okay.scala3.*
import okay.scala3.std.{Coeffects, History}

/** WANDER: a coeffect — a call's observation decided with the history behind it. After `after` reads and searches
 * in a row (and every `after` more), the observation tells the model so: if what it looks for is not in this project,
 * say so and answer with what it found. Which calls run is not changed, only what the model reads (seen on Qwen3.6: a
 * question about something the project did not have, 40 turns of grep and read) */
object Wander:
  /** the reads and searches just before the focus, one after another */
  def readsInRow(h: History[Boolean]): Int = h.past.reverseIterator.takeWhile(identity).size

  def note(n: Int): String =
    s"\n\n(note: $n reads and searches in a row. If what you look for is not in this project, say so now and " +
      "answer with what you found.)"

  def nudging[R[_], A](tools: Vector[ToolSpec], after: Int = 12)(p: A ! R)(using In[Tools, R]): A ! R =
    def reads(c: Call) = tools.find(_.name == c.name).exists(_.kind == ToolSpec.Kind.Read)
    if after <= 0 then p
    else Coeffects.aroundHistory[Tools, Boolean, R, A](p)(
      [X] => (op: Tools[X]) => op match { case Tools.Perform(c) => reads(c) },
      [X] => (op: Tools[X], x: X) => op match { case Tools.Perform(c) => reads(c) })(
      [X] => (h: History[Boolean], op: Tools[X], proceed: X ! R) => op match
        case Tools.Perform(c) if reads(c) && (readsInRow(h) + 1) % after == 0 =>
          proceed.map(o => o.copy(text = o.text + note(readsInRow(h) + 1)))
        case _ => proceed)
