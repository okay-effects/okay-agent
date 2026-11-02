package okay.agent

import okay.effects.json.Json
import okay.llm.{Ask, Finished, Llm}
import okay.scala3.*

/** HOW FAR IT MAY GO: the model's turns, the tokens it makes */
final case class Budget(turns: Int = 40, tokens: Int = 32000)

/** HOW A RUN ENDED */
enum Outcome:
  /** the model answered with no call: its last words */
  case Done(summary: String)
  /** a turn or a token too many: which */
  case OutOfBudget(what: String)

/** THE AGENT'S STATE, data: the conversation (as a chat template takes it), the tools offered, what it spent */
final case class Ctx(messages: Vector[Json], tools: Vector[ToolSpec], budget: Budget, turns: Int = 0,
    tokens: Int = 0, maxTokens: Int = 4096):
  /** the request of this turn: the conversation, the tools offered */
  def ask: Ask = Ask(messages, tools.map(_.json), maxTokens)

object Agent:
  private def s(t: String) = Json.Str(t)
  private def msg(role: String, content: String) = Json.obj("role" -> s(role), "content" -> s(content))

  /** short on purpose: a local model reads it each new session (Claude Code's is ~14k tokens) */
  val system: String =
    """You are a coding agent working in a project directory. Do the task with the tools, then stop.
      |Rules:
      |- Act with tool calls; one step at a time; read before you edit.
      |- Paths are relative to the project directory.
      |- Prefer `edit` (replace an exact fragment) over rewriting a whole file.
      |- When the task is done, answer in a few sentences with no tool call: that ends the run.""".stripMargin

  /** `notes`: lines added to the system prompt — what the tools offered this run are for */
  def start(task: String, tools: Vector[ToolSpec], budget: Budget = Budget(), notes: Vector[String] = Vector.empty)
      : Ctx =
    Ctx(Vector(msg("system", (system +: notes.map("- " + _)).mkString("\n")), msg("user", task)), tools, budget)

  /** THE PROGRAM: ask the model; no call — done; else each call performed, its observation appended; again — until
   * done or out of budget. Each turn's request is the last one with turns appended, never changed before them (the
   * prefix law: the model's cache keeps it) */
  def run[R[_]: Has[Llm] : Has[Tools]](ctx: Ctx): Outcome ! R =
    loop[Ctx, Outcome, R](ctx) { c =>
      if c.turns >= c.budget.turns then pure(Right(Outcome.OutOfBudget(s"${c.turns} turns")))
      else if c.tokens >= c.budget.tokens then pure(Right(Outcome.OutOfBudget(s"${c.tokens} tokens")))
      else Llm.complete[R](c.ask).flatMap { f =>
        val calls = f.reply.toolCalls.zipWithIndex.map((t, k) => Call(s"call_${c.turns}_$k", t.name, t.arguments))
        val spent = c.copy(messages = c.messages :+ turn(f, calls), turns = c.turns + 1,
          tokens = c.tokens + f.timing.tokens)
        if calls.isEmpty then pure(Right(Outcome.Done(f.reply.content)))
        else each(calls)(call => Tools.perform[R](call).map(o => observation(call, o)))
          .map(obs => Left(spent.copy(messages = spent.messages ++ obs)))
      }
    }

  /** calls one after another, their results in order */
  private def each[A, B, R[_]](as: Vector[A])(f: A => B ! R): Vector[B] ! R =
    as.foldLeft(pure[Vector[B], R](Vector.empty))((acc, a) => acc.flatMap(bs => f(a).map(bs :+ _)))

  /** the model's turn as the conversation keeps it: its text, its calls (arguments as JSON) */
  private def turn(f: Finished, calls: Vector[Call]): Json =
    Json.Obj(Vector("role" -> s("assistant"), "content" -> s(f.reply.content)) ++
      (if calls.isEmpty then Vector.empty else Vector("tool_calls" -> Json.Arr(calls.map(c => Json.obj(
        "id" -> s(c.id), "type" -> s("function"),
        "function" -> Json.obj("name" -> s(c.name), "arguments" -> c.args)))))))

  private def observation(call: Call, o: Obs): Json =
    Json.obj("role" -> s("tool"), "tool_call_id" -> s(call.id),
      "content" -> s(if o.error then s"error: ${o.text}" else o.text))
