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
| decode | the sampling loop: masks, forces or biases the next token | per token, no extra tokens | okay-mlx |
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

### What is already there, and what the state is (findings, 2026-11-03)

- mlx-scala already has the continuation as a value: `State.snapshot()` / `Model.restore(snapshot)` (restore twice:
  two independent branches — multi-shot without replay), `checkpoint()` / `rewind(c, keep)` (used by `Generate` to
  undo wrong guesses — multi-shot in production), `PrefixCache` (LRU, 4 GiB), `PrefixStore` (on disk, the law "a
  prefix from disk, the same answer"). Stage 3 is mostly **exposing** this, not building it.
- Qwen3.6 / 3.5 is hybrid: of 40 layers, 10 full attention (a KV cache growing with length: 10 × (K+V) × 2 heads ×
  256 × 2 bytes = **20 KiB a token**) and 30 Gated DeltaNet (a recurrent state of fixed size: 32 × 128 × 128 ×
  float32 = 2 MiB a layer, **60 MiB in all**, plus ~1.4 MiB of convolution windows). A snapshot: ~82 MiB at 1k
  tokens, ~260 MiB at 10k, ~2.0 GiB at 100k, ~5.1 GiB at 262k.
- A recurrent state cannot be cut back to a shorter prefix: the points one can return to must be **declared in
  advance** (snapshots at marks, as `PrefixCache` does at `Chat.marks`). A decode module that may roll back (a
  secret → `[hidden]`) snapshots **before** the suspicious place; it cannot roll back after the fact.
- A full continuation is more than the model's state: position, the sampler's state (seed, the penalties' history),
  the decode modules' states, the handle table. Without the seed, two branches from one snapshot sample differently
  (fine for "what if", wrong for exact resumption).
- Copy-on-write: branches share the full-attention KV of their common prefix (pages, as paged attention); the 60 MiB
  of recurrent state is copied whole. A fork at 10k tokens then costs ~60 MiB, not ~260.
- The law, as a property test: `restore(snapshot(s))` then feeding `x` ≡ `s` then feeding `x` (logits bit-equal).
- Measure first (M4 Max, Qwen3.6-35B): prefill of 10k and 30k tokens; save/load of a snapshot that size through
  `PrefixStore`; restore ×3 and a short continuation with the law checked. These decide how much "resume at once"
  and "forks" are worth.
- Gateway API sketch: `POST /v1/sessions/{id}/snapshot` → id; `/fork?from=` → a new session; `/save`, `/load`;
  `/rewind?to=`.
- Practical value (why): resume yesterday's long session at once (load ~0.5 GiB instead of re-reading 30k tokens);
  "go back to before X" without the wrong turn left in the context; branches of a conversation kept side by side;
  best-of-n with tests for a weaker local model (no re-prefill per attempt); coherent text after a decode module's
  rollback; a risky step tried in a branch and chosen from the phone (okay-remote); debugging from the step before a
  failure instead of re-running everything.
- Not in the cloud: a Durable Object cannot hold a 35B model's state; there the continuation is the transcript and
  resuming is re-sending (replay softened by prompt caching). Remote APIs have no state at all.

## Stage 4 — the module manifest in okay-llm, policies in okay-guard

- okay-llm: generation is an effect; modules are interceptors/handlers on it; the manifest (ports, effects, tests,
  signature) and the capability negotiation (text ↔ decode fallback by backend).
- okay-guard: which modules and ports are allowed, their declared effects enforced, signatures checked; audit per
  call (text) or per generation summary (decode).
- okay-remote: modules' activity on the phone; approval of modules with outside effects; choosing a fork's branch.


## Stage 5 — nondeterminism and search as effects (operator, 2026-11-03)

The model proposes, logic disposes. Search is a program over effects; the strategy is a handler.

- Effects: `choose` (a choice point: take an alternative the model proposes), `fail` (an exact check rejected the
  branch), `prove` (a step of a derivation, kept for the answer's proof).
- `choose` = a KV snapshot (stage 3: mlx-scala's `snapshot` / `restore` — multi-shot, no replay); `fail` = restore
  the latest choice point and take the next alternative. The failed branch disappears from the context physically
  (the KV is restored), so it cannot bias the next attempt.
- Checks are handlers: the compiler, the tests, a type check, a JSON Schema, an ontology's rules, okay-facts' data.
- Search strategies are handlers of the same program: depth-first (Prolog), best-first by the model's own
  probabilities (the default), beam. Diversity of alternatives is asked for explicitly (models propose look-alikes).
- Answers carry a proof: which checks passed, which facts (exact, with sources) and which model judgements
  (marked, with their confidence) a conclusion rests on.
- First use in okay-agent: hypotheses of a fix (or of a failure's cause) as choice points, compile + tests as `fail`,
  best-first; measured on `bench/` against plain retries (tasks solved, wall time, tokens).
- Logic itself (unification, rules) runs in an ordinary engine on the CPU as a handler; for rules over facts a
  Datalog engine (monotone, bottom-up — OWL 2 RL is Datalog), Prolog-style search only where alternatives are
  generated. Logic compiled into weights is research (okay-inlay), not this stage.
- Risks: search explosion (bound depth and branching, best-first), noisy model judgements (probabilistic facts,
  marked in proofs), correlated alternatives.
## Later

Activation and weights ports, with compiled modules (the transformer-compilation track: okay-inlay).

## Gotchas

- A handle table is per run; compaction must keep it (or re-issue handles) — the compaction law covers acts, extend
  it to handles.
- Masks must never make generation impossible: a module that leaves no allowed token is a bug; the gateway falls
  back to unmasked with a recorded violation.
- Forking needs isolated worlds: a branch never writes the real workspace before it is chosen.
- Remote models get only the text port; nothing here may break okay-agent with a remote backend.
