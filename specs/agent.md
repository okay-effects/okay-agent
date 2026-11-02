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
- **ACP** — `okay-agent acp`: okay-remote offers "okay-agent · <model>" like opencode.
- **AG-UI** — `okay-agent serve`: `POST /agent` (AG-UI's transport), any AG-UI client a front end.

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
2. Compaction and its law; the prefix kept across turns; journal and replay.
3. ACP: okay-agent in okay-remote, with the policy and the phone.
4. AG-UI: the shared events, okay-agent's server, okay-remote's endpoint.
5. The forecast as an input of the policy.

Tools of the first version: `read`, `write`, `edit` (replace a fragment), `bash`, `glob`, `grep`, `git_commit`. The
system prompt short, in English, the tool-call rules explicit for Qwen.
