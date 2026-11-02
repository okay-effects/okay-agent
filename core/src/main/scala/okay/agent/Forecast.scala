package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Finished, Llm}
import okay.scala3.*

/** A FORECAST: what the agent would do after a call — the same program run on from the same conversation, the model
 * the real one (the conversation's prefix its cache's), the calls answered by a hypothesis (nothing touched: reads may
 * be real, the rest imagined done). Its acts, the risky ones among them, and how it would end within the horizon. As
 * good as the hypothesis: it gets the shape (what comes), not the content */
final case class Forecast(acts: Vector[Call], risky: Vector[(Call, String)], turns: Int, ended: Option[Outcome]):
  /** a line for a person: what comes, what is risky in it */
  def summary: String =
    val what = if acts.isEmpty then "nothing more" else acts.map(Forecast.brief).mkString(", ")
    val end = ended match
      case Some(Outcome.Done(_)) => s"then done ($turns turns)"
      case _ => s"not done within $turns turns"
    s"forecast: then $what; $end" +
      (if risky.isEmpty then "" else risky.map((c, why) => s"${Forecast.brief(c)} ($why)").mkString("; ⚠ ", ", ", ""))

object Forecast:
  /** what makes an act risky: not to be undone by its kind, or a command that destroys, rewrites history, publishes,
   * or runs what it downloads (RE2: Scala Native's too) */
  private val commands: Vector[(scala.util.matching.Regex, String)] = Vector(
    "\\bgit\\s+push\\b".r -> "pushes",
    "\\bgit\\s+(reset\\s+--hard|clean\\s+-[a-z]*f|checkout\\s+--\\s|restore\\b|rebase\\b|filter-branch\\b)".r ->
      "throws work away",
    "\\brm\\s+(-[a-zA-Z]*[rf]|--recursive|--force)".r -> "removes files",
    ("\\b(npm|yarn|pnpm|cargo)\\s+publish\\b|\\bsbt\\b.*\\bpublish\\b|" +
      "\\bgh\\s+(release|pr\\s+merge)\\b").r -> "publishes",
    "(curl|wget)[^|]*\\|\\s*(ba|z)?sh\\b".r -> "runs what it downloads",
    "\\b(sudo|mkfs|dd\\s+if=|chmod\\s+-R|chown\\s+-R)\\b".r -> "changes the machine",
    "(?i)\\b(drop\\s+(table|database)|truncate\\s+table)\\b".r -> "drops data",
    "\\b(kubectl\\s+(apply|delete)|terraform\\s+(apply|destroy)|docker\\s+push)\\b".r -> "changes what is deployed")

  def danger(tools: Vector[ToolSpec])(c: Call): Option[String] =
    if tools.find(_.name == c.name).exists(_.kind == ToolSpec.Kind.Irreversible) then Some("not to be undone")
    else c.args.field("command").collect { case Json.Str(cmd) => cmd }
      .flatMap(cmd => commands.collectFirst { case (re, why) if re.findFirstIn(cmd).isDefined => why })

  def brief(c: Call): String =
    val main = Vector("command", "path", "message", "pattern", "query").flatMap(k =>
      c.args.field(k).collect { case Json.Str(v) => v }).headOption.map(v => " " + v.linesIterator.nextOption()
      .getOrElse("").take(60)).getOrElse("")
    c.name + main

  /** the forecast after `now` from `ctx` (the conversation up to and with the call's turn, its calls answered so far):
   * `now` and `rest` (the calls still to come in that turn) imagined done, then the program on, `horizon` turns at
   * most. Its acts: `rest`, then what the program does */
  def of[R[_]: Has[Llm]](ctx: Ctx, now: Call, rest: Vector[Call], tools: Vector[ToolSpec], horizon: Int,
      imagine: Call => Obs): Forecast ! R =
    val first = ctx.copy(messages = ctx.messages ++ (now +: rest).map(c => Agent.observation(c, imagine(c))),
      budget = Budget(turns = horizon, tokens = horizon * 2048), turns = 0, tokens = 0)
    Agent.runWith[R](first)(c => pure(imagine(c))).map { (outcome, end) =>
      val acts = rest ++ Agent.callsIn(end.messages.drop(first.messages.size))
      Forecast(acts, acts.flatMap(c => danger(tools)(c).map(c -> _)), end.turns, outcome match
        case d: Outcome.Done => Some(d)
        case _ => None)
    }

  /** THE GATE ON A FORECAST: before a call that is not a read, what comes after it forecast; `decide` says from the
   * call and its forecast whether a person is asked (by default the call or anything ahead risky) — asked, the
   * forecast is in the question; not asked, it goes on. The forecast's requests go to the model outward of this
   * interceptor (not shown, not compacted; journalled where a journal is outward) */
  def gate[R[_], A](tools: Vector[ToolSpec], horizon: Int, imagine: Call => Obs,
      decide: Option[(Call, ToolSpec.Kind, Forecast) => Boolean] = None)(p: A ! R)
      (using In[Llm, R], In[Tools, R], In[Human, R]): A ! R =
    val ask = decide.getOrElse(asks(tools, Vector.empty))
    var lastAsk: Option[Ask] = None
    var lastTurn: Option[Finished] = None
    var turn = -1
    var answered = Vector.empty[(Call, Obs)]
    val heard = around[Llm, R, A](p)([X] => (op: Llm[X], proceed: X ! R) => op match
      case Llm.Start(a) => lastAsk = Some(a); proceed
      case Llm.Finish(_) => proceed.map { f =>
        lastTurn = Some(f); turn += 1; answered = Vector.empty
        f
      }
      case _ => proceed)
    around[Tools, R, A](heard)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) =>
        val kind = tools.find(_.name == call.name).map(_.kind).getOrElse(ToolSpec.Kind.Exec)
        def done(o: Obs): Obs = { answered :+= (call, o); o }
        (lastAsk, lastTurn) match
          case (Some(a), Some(f)) if kind != ToolSpec.Kind.Read =>
            // the turn's own number, from the call's name (call_<turn>_<k>)
            val n = call.id.split('_').lift(1).flatMap(_.toIntOption).getOrElse(turn)
            val calls = Agent.callsOf(f, n)
            val rest = calls.dropWhile(_.id != call.id).drop(1)
            val ctx = Ctx(a.messages :+ Agent.turn(f, calls), tools, Budget(), maxTokens = a.maxTokens)
            val sofar = ctx.copy(messages = ctx.messages ++ answered.map((c, o) => Agent.observation(c, o)))
            Forecast.of[R](sofar, call, rest, tools, horizon, imagine).flatMap { fc =>
              if !ask(call, kind, fc) then proceed.map(done)
              else Human.ask[R](s"${kind.toString.toLowerCase} — ${call.name} ${call.args.render}" +
                  danger(tools)(call).fold("")(why => s" ⚠ $why") + s"\n  ${fc.summary}\n" +
                  "  allow? [y/N] ").flatMap(a => if a.trim.toLowerCase.startsWith("y") then proceed.map(done)
                  else pure(done(Obs(s"the person did not allow it${if a.trim.isEmpty then "" else s": $a"}",
                    error = true))))
            }
          case _ => proceed.map(done))

  /** the decision: ask when the call itself (by `tools`' kinds, by its command), or anything the forecast sees ahead,
   * is risky; `always` kinds asked whatever the forecast */
  def asks(tools: Vector[ToolSpec], always: Vector[ToolSpec.Kind]): (Call, ToolSpec.Kind, Forecast) => Boolean =
    (call, kind, fc) => always.contains(kind) || danger(tools)(call).isDefined || fc.risky.nonEmpty
