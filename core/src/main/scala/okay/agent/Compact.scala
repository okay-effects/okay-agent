package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Llm}
import okay.scala3.*

/** COMPACTION: over the window, the model sees the conversation shortened — the system prompt and the task, a summary
 * of the earlier turns (made by the same `Llm`), the latest turns word for word — while the program keeps it whole.
 * The summary stays until the next compaction, so between two the requests still only append (the prefix law holds
 * but across a compaction, as it must: a compaction re-reads the prompt — its cost).
 *
 * Its law: invisible in what the agent does — under one hypothesis, the trace of acts the same with it and without
 * it (LawsSuite) */
object Compact:
  /** how it shortens: over `trigger` of the window, the turns before the latest `keep` of it summarized; the latest
   * turn kept always (`keepLatest` false: the law's negative control — the flaw it caught) */
  final case class Window(tokens: Int, trigger: Double = 0.8, keep: Double = 0.4, keepLatest: Boolean = true)

  /** the first messages kept always: the system prompt, the task */
  val head = 2

  /** the conversation as the model sees it: the head, the summary of the `cut` messages after it, the rest */
  def view(messages: Vector[Json], cut: Int, summary: String): Vector[Json] =
    if cut == 0 then messages
    else messages.take(head) ++ Vector(Json.obj("role" -> Json.Str("user"),
      "content" -> Json.Str(s"(Summary of the work so far, the earlier turns compacted.)\n$summary"))) ++
      messages.drop(head + cut)

  def within[R[_], A](window: Window)(p: A ! R)(using In[Llm, R]): A ! R =
    var cut = 0
    var summary = ""
    def size(ms: Vector[Json], ask: Ask): Int ! R = Llm.count[R](ask.copy(messages = ms))
    around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Start(ask) =>
        val seen = view(ask.messages, cut, summary)
        size(seen, ask).flatMap { n =>
          if n <= window.tokens * window.trigger then Llm.start[R](ask.copy(messages = seen))
          else
            // the newest messages within `keep` of the window kept; the cut at a turn of the model's (its calls and
            // their observations stay together)
            val body = ask.messages.drop(head)
            def keptFrom(i: Int): Int ! R = if i >= body.length then pure(body.length) else
              size(ask.messages.take(head) ++ body.drop(i), ask).flatMap(k =>
                if k <= window.tokens * window.keep && body(i)("role").string == "assistant" then pure(i)
                else keptFrom(i + 1))
            // the latest turn of the model's, with its observations, kept always — even over `keep`: cut it, and the
            // model no longer sees where it is (the law caught it: the agent began again)
            val last = body.lastIndexWhere(_("role").string == "assistant")
            keptFrom(math.max(cut, 1)).map(f => if window.keepLatest then math.min(f, math.max(last, 0)) else f)
              .flatMap { from =>
              if from <= cut then Llm.start[R](ask.copy(messages = seen))   // nothing more to cut
              else summarize[R](summary, body.slice(cut, from), ask).flatMap { s =>
                cut = from
                summary = s
                Llm.start[R](ask.copy(messages = view(ask.messages, cut, summary)))
              }
            }
        }
      case _ => proceed)

  /** the turns cut, with the summary they follow, summarized by the model */
  private def summarize[R[_]](before: String, turns: Vector[Json], ask: Ask)(using In[Llm, R]): String ! R =
    val text = turns.map { m =>
      val role = m("role").string
      val calls = m.field("tool_calls").map(_.list.map(c => s" calls ${c("function")("name").string} " +
        c("function")("arguments").render).mkString).getOrElse("")
      s"[$role]$calls ${m.field("content").collect { case Json.Str(t) => t }.getOrElse("").take(2000)}"
    }.mkString("\n")
    val prompt = (if before.isEmpty then "" else s"The summary so far:\n$before\n\n") +
      s"The turns since:\n$text\n\nSummarize the work so far for yourself to continue it: what was done, what was " +
      "found (files, names, results), what is left. Be brief and exact."
    Llm.complete[R](Ask(Vector(Json.obj("role" -> Json.Str("system"), "content" -> Json.Str(Summarizer)),
      Json.obj("role" -> Json.Str("user"), "content" -> Json.Str(prompt))), maxTokens = 1024)).map(_.reply.content)

  /** a summary's own system prompt: told apart from the agent's */
  val Summarizer = "You summarize a coding agent's work for it to continue."
