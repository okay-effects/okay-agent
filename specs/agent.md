# okay-agent — a coding agent as one program over effects

## What and why

A coding agent of our own, local models first. Claude Code and opencode stay (okay-remote runs them); this one is for
where they are a poor fit:

- **A short prompt.** Claude Code's system prompt is ~14k tokens: on a local model, 15–60 s of prefill each new session.
  Ours: 1–2k.
- **The prefix law.** okay-mlx's prefix cache answers an agent's next turn in 0.2 s instead of 16 — while the prompt's
  beginning does not change. Ours keeps it by construction, and a test proves it (mlx-scala's PrefixLawSuite).
- **Control and audit.** Every step goes through us: okay-guard's policy, the journal, later a forecast. Another
  agent shows what it chooses to (opencode ran its shell unasked).
- **A small window.** Compaction made for a local model's context, checked by a law.

## The model: one program, a closed alphabet of effects

| effect | means | where |
|---|---|---|
| `Llm` | ask the model: the context and the tools offered → text, thoughts, tool calls | okay-llm |
| `Tools` | perform a tool call → an observation (a result or an error) | here |
| `Human` | ask a person → go on, a reply, no | here |
| `Clock`, `Log`, `Fresh` | time, log, ids | okay-scala std |

```scala
def agent(task: String, tools: Vector[ToolSpec]): Outcome ! (Llm + Tools + Human + Clock + Log)
// ask → each call performed → its observation appended → … → Done(summary) | GaveUp(why) | OutOfBudget
```

`Ctx` is data: the conversation, the tools offered, the budget (tokens, steps, time), the mode. The program is
deterministic; what comes back is not. No second representation of the agent (no coalgebra beside it): the program is
the agent, interpreters are handlers.

## Handlers: one program, many worlds

- `Llm`: in process (`Llm.on(MlxBackend)`); over HTTP to a gateway (`Llm.http(url)`, OpenAI's chat completions,
  streamed — new in okay-llm); scripted (a hypothesis: tests, the forecast).
- `Tools`: **Local** (files confined to the workspace, `bash` with a timeout, git) when it runs alone; **Acp** — it
  speaks ACP as an agent and its client performs the tools: under okay-remote, through okay-guard (policy, the phone,
  the journal) with nothing new there; **Pure** (a hypothesis: invented observations, nothing touched).
- `Human`: the terminal (CLI), AG-UI or ACP (the phone), scripted.

## Interceptors: behaviour above, the core untouched

Each guarantee is a handler transformer, on or off, tested alone:

1. **admit** — a call to a tool not offered, or with arguments off its schema, is not performed: the model observes an
   error ("no such tool; there are: …"). A local Qwen does this within minutes.
2. **budget** — the model's turns and the tokens it makes: part of the program itself (`Ctx.budget`, checked each
   turn), so the run ends honestly with `OutOfBudget`, not cut from outside.
3. **compaction** — over the window: the oldest turns become a summary (by the same `Llm`), the prefix before it kept.
4. **gate** — every `Tools` call through okay-guard's policy: allow, deny, or ask `Human` (under Acp, the client's).
5. **journal** — every step in okay-guard's Ledger (a hash chain); a run replayed from it without a model.
6. **events** — the trace as AG-UI events for any client.
7. **forecast** (last) — before a risky call, a copy of the continuation run under a hypothesis: steps left,
   irreversible acts → a risk the policy may use. As good as the hypothesis (theirs got the shape, not the content).

## Laws: each guarantee a property test

States only through real transitions (the program run on a hypothesis's random answers), never built by hand.

- **admit**: no trace performs a call absent from the tools offered at that node — under a hostile model too.
- **prefix**: `render(ctx + turn)` begins with `render(ctx)`, token for token, outside a compaction.
- **compaction**: under one hypothesis, the trace of `Tools` acts is the same with and without it — a violation rate
  over many runs, never one example.
- **termination**: under any hypothesis, with a budget, it halts.
- **replay**: run from the journal, the same trace.

## Surfaces

- **CLI** — `okay-agent "<task>"` in a workspace: the terminal its `Human`, local tools, the model over HTTP
  (okay-mlx's gateway by default) or in process; `--model`, `--budget`, `--replay <journal>`.
- **ACP** — `okay-agent acp` (JSON-RPC over stdio; `OKAY_AGENT_URL`, `OKAY_AGENT_MODEL`): okay-remote offers
  "okay-agent · <model>" for each model okay-llm's gateway lists. The same program, other handlers: `read`, `write`
  and `edit` through the client's `fs/read_text_file` / `fs/write_text_file`, `bash` and `git_commit` a shell line
  run by the client's terminal (`terminal/create` with the line as `command`, as okay-guard's terminals take it) — so
  the client's gate weighs each, and the agent's own gate is off; `glob`, `grep` and symdex here (reads); an MCP tool
  that may change something asked through `session/request_permission`. A client without fs or terminal: the
  workspace's own tools. Each call shown before and after (`tool_call` with `rawInput.file_path` absolute or
  `rawInput.command` — what the client's requests carry, so a request finds its call — then `tool_call_update`), the
  model's words as `agent_message_chunk`. A session's prompts go on in one conversation (`Agent.runOn` gives the
  conversation it ended with, `Agent.next` appends the next prompt: the prefix law across prompts). `session/cancel`
  seen between steps: the prompt ends `cancelled`. One thread: requests of the agent's answered while it waits.
- **AG-UI** — `okay-agent serve [--port 8091] [--dir D] [--yes]`: `POST /agent` (RunAgentInput) answered with the
  run's events as SSE (okay-llm's `AgUi`, AG-UI 1.0), any AG-UI client a front end. An AG-UI thread is one
  conversation kept here (`Agent.runOn`/`next`: the prefix law across runs); a thread's first run keeps the user and
  assistant texts the client sent before. Each call shown (TOOL_CALL_START/ARGS/END before, TOOL_CALL_RESULT after),
  the model's words between calls and its last as a text message. A call to be asked about (writes, commands, commits
  unless `--yes`) ends the run with an interrupt (`outcome: interrupt`, reason `approval`, its `toolCallId`, payload
  `{approved, reason?}`); the program waits for it ALIVE on its thread — no replay — and the next run's `resume`
  answers it, the program going on, its events on that run's stream (no answer in 30 minutes: the run cancelled). A
  new prompt while it waits, or while a run is on: RUN_ERROR. A client gone mid-run: cancelled before the next step.
  Order of interceptors (the innermost sees a call first): shown, then admitted, then gated.

## Where it lives

- This repository: `core` (program, effects, interceptors, laws; JVM + Native), `tools` (local), `acp` (the agent
  side), `agui` (the server), `cli`.
- okay-llm: `Llm.http`; the AG-UI events (shared: okay-remote streams its sessions as AG-UI too).
- okay-remote: the "okay-agent · <model>" entry (ACP); an AG-UI endpoint for every session.

## Order

0. The prefix law in mlx-scala and okay-llm — done 2026-11-02 (PrefixLawSuite; the gateway asks Qwen3.6's template to
   keep past think blocks).
1. Core: effects, the loop, tool specs, admit, budget, trace, hypothesis; the admit and termination laws; `Llm.http`,
   local tools, the CLI. Measured against Claude Code on one task: prompt size, time to the first act, to the result.
   — done 2026-11-02: okay-llm's `HttpBackend` (any OpenAI chat-completions server); core `Agent`, `Tools`, `Human`,
   `Admit`, `Gate`, `Hypo`; laws admit (not vacuous: most hostile calls refused), termination, the prefix law, the
   gate — 300 runs each, JVM and Native; the CLI's workspace tools. First real run (Qwen3.6-35B via okay-mlx):
   rename → check → commit in 5 turns, the first prompt 887 tokens.
2. Compaction and its law; the prefix kept across turns; journal and replay. — done 2026-11-02: `Compact.within`
   (the model sees system + task + a stable summary + the latest turns; the latest turn kept always — the law caught
   its loss, the agent began again; `keepLatest = false` is now the negative control), laws: invisible in acts (200
   runs, compactions happened), the control caught, appends only between compactions; `Journal` (an effect) and
   `Journal.recording`, `Replay.from` (strict, no model, no world), law: the same acts and end (200 runs). CLI:
   `--window`, the journal in ~/.okay-agent/journals, `--replay`. On Qwen3.6: compacted mid-task, finished right, the
   head still cached (885 of 1043).
2b. MCP with no setting — done 2026-11-02: the project's `.mcp.json` servers and symdex (where an index is, symdex
   installed: `symdex serve --root <ws> --lean`) started, their tools the agent's (symdex's read-only, others asked
   about); `symdex_setup` (sbt: its plugin, `sbt symdexIndex symdexMcp`); a system note and a nudge on a symbol grep
   that found nothing. Admit sets plain scalars right ("True" → true, "3" → 3). On Qwen3.6: set symdex up in one turn
   (33 s); the next run answered with `implementations` and `references` (a grep had missed `p.price`).
3. ACP — done 2026-11-02: `okay-agent acp` (AcpSuite: a client of the test's — the edit through fs, the command
   through its terminal, the calls shown, a refused write a failed call, a second prompt in the same conversation, a
   client with no fs: the workspace's tools); okay-remote's "okay-agent · <model>".
4. AG-UI — done 2026-11-02: okay-llm's `AgUi` (AG-UI 1.0's events, interrupts, RunAgentInput); `okay-agent serve`
   (ServeSuite: a write asked by an interrupt, the program waiting alive, resumed, going on; a refusal the model's
   observation; a thread's runs one conversation); okay-remote's `POST /agui` (every session, whatever its agent).
   Checked with AG-UI's own client (@ag-ui/client, which verifies the stream) on Qwen3.6-35B: two approvals by
   resume, the file, the answer 42 — against `okay-agent serve`, and against okay-remote with okay-agent inside.
5. The forecast as an input of the policy.

Tools of the first version: `read`, `write`, `edit` (replace a fragment), `bash`, `glob`, `grep`, `git_commit`. The
system prompt short, in English, the tool-call rules explicit for Qwen.
