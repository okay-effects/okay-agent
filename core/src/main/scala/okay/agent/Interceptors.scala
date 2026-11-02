package okay.agent

import okay.effects.json.Json
import okay.scala3.*

/** ADMIT: a call is performed only if its tool was offered and its arguments fit the tool's schema; else the model
 * observes why — the call never reaches the world. A local model calls tools it was not offered, or with arguments
 * astray, within minutes: repaired into an observation, not performed. A scalar of the wrong type but plain meaning
 * — "true" for a boolean, "3" for a number (Qwen writes Python's True) — is set right first, not refused */
object Admit:
  def within[R[_], A](tools: Vector[ToolSpec])(p: A ! R)(using In[Tools, R]): A ! R =
    around[Tools, R, A](p)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) =>
        val set = tools.find(_.name == call.name)
          .fold(call)(t => call.copy(args = Schema.coerce(t.parameters, call.args)))
        refusal(tools, set) match
          case Some(why) => pure(Obs(why, error = true))
          case None => if set == call then proceed else Tools.perform[R](set))

  /** why a call is not admitted, if it is not */
  def refusal(tools: Vector[ToolSpec], call: Call): Option[String] =
    tools.find(_.name == call.name) match
      case None => Some(s"no tool '${call.name}'; the tools are: ${tools.map(_.name).mkString(", ")}")
      case Some(t) => Schema.mismatch(t.parameters, call.args).map(m => s"'${call.name}': $m")

/** a JSON Schema's object, enough of it to check a call: the required properties there, each given one of its type */
object Schema:
  def mismatch(schema: Json, args: Json): Option[String] = args match
    case Json.Obj(fields) =>
      val present = fields.toMap
      val required = schema.field("required").map(_.list.collect { case Json.Str(n) => n }).getOrElse(Vector.empty)
      val props = schema.field("properties").map(_.record.toMap).getOrElse(Map.empty)
      required.find(n => !present.contains(n)).map(n => s"the argument '$n' is required")
        .orElse(present.collectFirst { case (n, v) if props.get(n).exists(p => !fits(p, v)) =>
          s"the argument '$n' is not a ${props(n).field("type").map(_.render).getOrElse("value")}" })
    case _ => Some("the arguments are not an object")

  /** the arguments with a string set to the boolean or number its property wants, where it plainly is one */
  def coerce(schema: Json, args: Json): Json = args match
    case Json.Obj(fields) =>
      val props = schema.field("properties").map(_.record.toMap).getOrElse(Map.empty)
      Json.Obj(fields.map { (n, v) =>
        (props.get(n).flatMap(_.field("type")), v) match
          case (Some(Json.Str("boolean")), Json.Str(s)) if Set("true", "false")(s.trim.toLowerCase) =>
            n -> Json.Bool(s.trim.toLowerCase == "true")
          case (Some(Json.Str("integer" | "number")), Json.Str(s)) if s.trim.toDoubleOption.isDefined =>
            n -> Json.num(s.trim.toDouble)
          case _ => n -> v
      })
    case other => other

  private def fits(prop: Json, v: Json): Boolean = prop.field("type") match
    case Some(Json.Str(t)) => (t, v) match
      case ("string", _: Json.Str) | ("boolean", _: Json.Bool) => true
      case ("array", _: Json.Arr) | ("object", _: Json.Obj) => true
      case ("number" | "integer", _: Json.Num) => true
      case _ => false
    case _ => true

/** THE GATE: a call of a kind to be asked about is put to the person first; their no is the model's observation */
object Gate:
  def asking[R[_], A](tools: Vector[ToolSpec], ask: ToolSpec.Kind => Boolean)(p: A ! R)
      (using In[Tools, R], In[Human, R]): A ! R =
    around[Tools, R, A](p)([X] => (op: Tools[X], proceed: X ! R) => op match
      case Tools.Perform(call) => tools.find(_.name == call.name) match
        case Some(t) if ask(t.kind) =>
          Human.ask[R](s"${t.kind.toString.toLowerCase} — ${call.name} ${call.args.render}  allow? [y/N] ")
            .flatMap(a => if a.trim.toLowerCase.startsWith("y") then proceed
              else pure(Obs(s"the person did not allow it${if a.trim.isEmpty then "" else s": $a"}", error = true)))
        case _ => proceed)
