package okay.agent

import okay.llm.{Ask, Llm, Timing}
import okay.scala3.*

/** A HYPOTHESIS: a pure stand-in for the model — tests, and later the forecast. Its text is read as a model's (tool
 * calls in Qwen's JSON: `<tool_call>{"name": …, "arguments": …}</tool_call>`), each token a word */
object Hypo:
  def llm[R[_], Rest[_], A](answer: Ask => String)(p: A ! R)(using Split[Llm, R, Rest]): A ! Rest =
    Llm.on(Stand(answer))(p)

  /** a model's turn calling `name` with `args` (JSON text) */
  def call(name: String, args: String): String =
    s"<tool_call>\n{\"name\": \"$name\", \"arguments\": $args}\n</tool_call>"

  private final class Stand(answer: Ask => String) extends Llm.Backend:
    def name = "hypothesis"
    def count(ask: Ask) = ask.messages.map(_.render.length).sum / 4
    def start(ask: Ask) = new Llm.Generation:
      // words, each with the space after it (Scala Native's regex is RE2's: no look-behind)
      private val words =
        val t = answer(ask)
        val cuts = (t.indices.filter(t(_) == ' ').map(_ + 1) :+ t.length).distinct
        cuts.foldLeft((0, List.empty[String]))((acc, c) => (c, acc._2 :+ t.substring(acc._1, c)))._2
          .filter(_.nonEmpty)
      private var rest = words
      private val sb = new StringBuilder
      def next() = rest match
        case w :: more => rest = more; sb.append(w); Some(w)
        case Nil => None
      def text = sb.toString
      def timing = Timing(count(ask), 0L, words.size, 0L)
      def byStop = true
      def close() = ()
