package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Llm, Reply, Timing, ToolCall}
import okay.scala3.*

/** THE JOURNAL, as the program sees it: an entry written. Where it goes is the handler's: collected (a test), a file
 * of JSON lines (the CLI), okay-guard's Ledger (later) */
enum Journal[X]:
  case Write(entry: Json) extends Journal[Unit]

object Journal:
  private def s(t: String) = Json.Str(t)
  def write[R[_]](entry: Json)(using In[Journal, R]): Unit ! R = perform[Journal](Write(entry))

  /** the entries, in order, and the value */
  def collect[R[_], Rest[_], A](p: A ! R)(using Split[Journal, R, Rest]): (Vector[Json], A) ! Rest =
    handle(p, Handler.stateful[Journal, Rest, A, (Vector[Json], A), Vector[Json]](Vector.empty)(
      (es, a) => pure((es, a)))(
      [X] => (op: Journal[X], cell: Cell[Vector[Json]]) => op match
        case Write(e) => cell.set(cell.get :+ e)))

  /** each entry given to `f` as it is written: a file's line, a screen's */
  def to[R[_], Rest[_], A](f: Json => Unit)(p: A ! R)(using Split[Journal, R, Rest]): A ! Rest =
    handle(p, Handler.tail[Journal, Rest, A, A](pure)([X] => (op: Journal[X]) => op match
      case Write(e) => f(e)))

  /** RECORDING: each turn of the model's (its thinking, its text, its calls) and each act (the call, what it gave)
   * written as it happens — enough to replay the run with no model and no world (`Replay`) */
  def recording[R[_], A](p: A ! R)(using In[Llm, R], In[Tools, R], In[Journal, R]): A ! R =
    val turns = around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Finish(_) => proceed.flatMap(f => write[R](turn(f.reply)).as(f))
      case _ => proceed)
    around[Tools, R, A](turns)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(c) => proceed.flatMap(o => write[R](act(c, o)).as(o)))

  def act(c: Call, o: Obs): Json = Json.obj("k" -> s("act"), "id" -> s(c.id), "name" -> s(c.name), "args" -> c.args,
    "obs" -> s(o.text), "error" -> Json.Bool(o.error))

  def turn(r: Reply): Json = Json.obj("k" -> s("turn"), "reasoning" -> s(r.reasoning), "content" -> s(r.content),
    "calls" -> Json.Arr(r.toolCalls.map(c => Json.obj("name" -> s(c.name), "args" -> c.arguments))))

/** REPLAY: a run again from its journal — the model's turns and the acts' observations as written, in order; no
 * model, no world. Strict: an act that is not the one written is told so (the run diverged), not performed */
object Replay:
  def from[R[_], Rest1[_], Rest2[_], A](entries: Vector[Json])(p: A ! R)
      (using Split[Llm, R, Rest1], Split[Tools, Rest1, Rest2]): A ! Rest2 =
    val turns = entries.filter(_("k").string == "turn").iterator
    val acts = entries.filter(_("k").string == "act").iterator
    Tools.by[Rest1, Rest2, A] { c =>
      if !acts.hasNext then Obs(s"the replay diverged: no act written for ${c.name}", error = true)
      else
        val e = acts.next()
        if e("name").string != c.name || e("args") != c.args then
          Obs(s"the replay diverged: ${c.name} ${c.args.render}, written ${e("name").string} ${e("args").render}",
            error = true)
        else Obs(e("obs").string, e("error") == Json.Bool(true))
    }(Llm.on[R, Rest1, A](Recorded(turns))(p))

  private final class Recorded(turns: Iterator[Json]) extends Llm.Backend:
    def name = "replay"
    def count(ask: Ask) = 0
    def start(ask: Ask) = new Llm.Generation:
      private val e = if turns.hasNext then Some(turns.next()) else None
      private var shown = false
      def next() = if shown then None else { shown = true; e.map(_("content").string).filter(_.nonEmpty) }
      def text = e.map(_("content").string).getOrElse("")
      def timing = Timing(0, 0L, 0, 0L)
      def byStop = true
      def close() = ()
      override def reply(thinking: Boolean, tools: Seq[Json]) = e.fold(Reply("", "", Vector.empty))(j =>
        Reply(j("reasoning").string, j("content").string,
          j("calls").list.map(c => ToolCall(c("name").string, c("args")))))
