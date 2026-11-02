package okay.agent.cli

import okay.llm.{Llm, Streamer}
import okay.scala3.*

/** THE MODEL'S WORDS AS THEY COME: each piece of a turn's text given to `piece` as the model makes it — its thinking
 * and its tool calls' text left out (okay-llm's `Streamer`: a server's clean deltas pass as they are, a model's raw
 * text is cut at `<think>` and `<tool_call>`); at the turn's end `ended` told whether any came */
object Words:
  def streamed[R[_], A](piece: String => Unit ! R, ended: Boolean => Unit ! R)(p: A ! R)(using In[Llm, R]): A ! R =
    var streamer = Streamer(false)
    var any = false
    def give(parts: Vector[Streamer.Part]): Unit ! R =
      val t = parts.collect { case Streamer.Part.Text(v) => v }.mkString
      if t.isEmpty then unit[R] else { any = true; piece(t) }
    around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Start(ask) =>
        streamer = Streamer(ask.thinking)
        any = false
        proceed
      case Llm.Next(_) => proceed.flatMap { got =>
        give(got.fold(streamer.flush())(streamer.push)).as(got)
      }
      case Llm.Finish(_) => proceed.flatMap(f => ended(any).as(f))
      case _ => proceed)
