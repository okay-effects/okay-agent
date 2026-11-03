# Effects inside generation — okay-agent, symdex, okay-mlx (spec, 2026-11-03)

Status: specification, nothing implemented. From the operator's design session of 2026-11-03; the operator assigns
the implementation to another agent. It spans four repositories; this file is the plan, each repository's own spec
gets its section when its stage starts (spec first, then tests, then code).

## Why

okay-agent already treats the model, its tools and the person as effects, with interceptors (`Admit`, `Gate`) and
laws. Its boundary today is the conversation: a tool call is text the model writes, checked after it is written.
Coding agents fail on facts the model retypes — paths, symbol names, members, line numbers — and on malformed calls.
The idea carried over from the okay-facts design (fact resolver: the model refers, we resolve): **move the boundary
into generation**, where the runtime is ours (okay-mlx), and make the model refer instead of retype.

The model of it: an LLM is a program performing effects. An operation is a marker / tool call (or, deeper, a query
vector); a handler answers it — in the runtime, in the decoding loop, or compiled into weights; the continuation is
the rest of the generation, and in our own runtime it is the **KV cache**, a value that can be resumed, cloned and
saved (multi-shot without replay); interceptors see every operation, down to the token.

## Ports: where a module attaches

| Port | Attaches at | Cost of a call | Where available |
|---|---|---|---|
| text | the conversation: tool calls (MCP) | stop, JSON, re-prefill | everywhere |
| decode | the sampling loop: sees generated tokens, masks/forces/biases the next | per token, no extra tokens | local runtimes (okay-mlx) |
| activation | the forward pass: reads/writes the residual at a layer | inside one pass | okay-mlx only |
| weights | compiled modules inside the model | none | own open models (research, later) |

A module declares the ports it can use, preferred first, with fallbacks; the host declares the ports it supports;
the deepest common port is chosen (remote APIs: text; okay-mlx: decode and deeper). A module's manifest also
declares its effects (reads, writes, network), which okay-guard enforces, and ships conformance tests the host runs
at load. The text port is always exportable as an MCP server.

## Stage 1 — symbol handles (symdex + okay-agent; text port, any model)

- symdex's tools return **handles** with the visible part only: `#sym3: def welcome (hello.scala)`. The exact path,
  range, signature live in the session's handle table (per agent run; a handle not issued in this run is refused).
- okay-agent's editing and navigation tools accept handles: rename `#sym3`, insert after the definition of `#sym3`,
  read the body of `#sym3`, callers of `#sym3`. Paths and line numbers are filled in by symdex, never typed by the
  model. `Admit` refuses an unknown handle (the model observes why).
- The agent's reports bind locations as parameters (`{file}`, `{line}`), rendered from the handles.
- Measure on `bench/`: invented paths and symbols, wasted turns, against the current tools.

## Stage 2 — the decode port in okay-mlx

okay-mlx's gateway gets a decoding hook: per step, a module receives the tokens so far and returns a mask, a forced
sequence or a bias over the next token. Modules for okay-agent:

1. **Tool calls by the schema's grammar** — a call off its JSON Schema cannot be generated (today `Admit` catches it
   after the fact). `Admit` stays as the law's check; its refusals should drop to zero on the local model.
2. **Secrets cannot be printed** — the values from the project's `.env` and known tokens become forbidden token
   sequences; the model cannot output them even after reading the file. Owned by okay-guard (a policy), run by the
   gateway.
3. **Identifiers from symdex** (completion-guided decoding; see "Monitor-Guided Decoding of Code LMs with Static
   Analysis", NeurIPS 2023) — after `expr.` the mask allows only the members of `expr`'s type from symdex's index,
   plus names declared in the edit. Start with member access in Scala; measure compile errors per task.

The OpenAI-compatible surface stays as it is; the hook is configured per request (an extension field) or per
session.

## Stage 3 — KV snapshots and forks in okay-mlx

- API: snapshot a session's KV cache, fork a session from a snapshot (copy-on-write of the shared prefix), save and
  load a snapshot (disk).
- okay-agent: at a decision point ("how to fix"), fork 2–3 branches, run the tests in each (each branch's world a
  scratch copy of the workspace), keep the passing one — search instead of retry. A branch's dangerous effects
  (writes, commands outside the scratch) handled by a test handler until the branch is chosen.
- Durable sessions: a long project session's KV saved and resumed the next day without re-prefill.
- Law: a fork's continuation equals the unforked run given the same handler answers (property test with `Hypo`).
- Measure: tasks solved, wall time, against retries.

## Stage 4 — the module manifest in okay-llm, policies in okay-guard

- okay-llm: generation is an effect; modules are interceptors/handlers on it; the manifest (ports, effects, tests,
  signature) and the capability negotiation (text ↔ decode fallback by backend).
- okay-guard: which modules and ports are allowed, their declared effects enforced, signatures checked; audit per
  call (text) or per generation summary (decode).
- okay-remote: modules' activity on the phone; approval of modules with outside effects; choosing a fork's branch.

## Later

Activation and weights ports, with compiled modules (the transformer-compilation track; its library's name is being
chosen by the operator).

## Gotchas

- A handle table is per run; compaction must keep it (or re-issue handles) — the compaction law covers acts, extend
  it to handles.
- Masks must never make generation impossible: a module that leaves no allowed token is a bug; the gateway falls
  back to unmasked with a recorded violation.
- Forking needs isolated worlds: a branch never writes the real workspace before it is chosen.
- Remote models get only the text port; nothing here may break okay-agent with a remote backend.
