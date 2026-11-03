# okay-agent

A coding agent as **one program over effects** — the model (okay-llm's `Llm`), its tools, a person — every world
handlers, every guarantee an interceptor with its law, tested as a property. Local models first: a short prompt
(~0.9k tokens to start, against Claude Code's ~14k), requests that only ever append (okay-mlx's prefix cache keeps
them), and every step ours to gate and record. The design: [`specs/agent.md`](specs/agent.md).

## Install (macOS, Apple Silicon)

```sh
curl -fsSL https://raw.githubusercontent.com/okay-effects/okay-agent/master/install.sh | sh
```

The command in `~/.okay-agent/bin`, linked from `~/.local/bin`; a model behind a server speaking OpenAI's chat
completions — [okay-mlx](https://github.com/okay-effects/okay-mlx)'s gateway on this Mac by default. Elsewhere:
`sbt cliNative/nativeLink` (or `cliJVM/run`). The libraries, for a program of your own:

```scala
resolvers += "okay-agent" at "https://okay-effects.github.io/okay-agent/maven"
libraryDependencies += "io.github.okay-effects" %%% "okay-agent" % "0.1.0"
```

## Use

```
okay-agent "Rename greet to welcome in hello.py, run it, commit"      # in a project directory
okay-agent --url http://127.0.0.1:8090/v1 --model mlx-community/Qwen3.6-35B-A3B-4bit --turns 40 --yes "…"
```

The model: any server speaking OpenAI's chat completions (okay-mlx's gateway by default, its first model; LM Studio,
Ollama, vLLM). Writes, commands and commits are asked about at the terminal first, unless `--yes`.

```scala
val outcome = run(Console.stdout(Human.by(terminal)(Tools.by(workspace.perform)(
  Llm.on(HttpBackend(url, model))(Gate.asking(tools, ask)(Admit.within(tools)(Agent.run[Row](ctx))))))))
```

- `core` — `Agent.run` (ask, perform the calls, append, again: until done or out of budget), the effects `Tools` and
  `Human`, the interceptors `Admit` (a call not offered, or off its schema, never performed: the model observes why)
  and `Gate` (a kind asked about put to the person), `Hypo` (a stand-in model). Laws: admit, termination, the prefix
  law, the gate — 300 runs each on a hostile model. JVM and Scala Native.
- `cli` — the workspace's tools (`read`, `write`, `edit`, `bash`, `glob`, `grep`, `git_commit`; inside the project
  alone), the terminal as the person. `sbt cliNative/nativeLink` for a native binary.

- `Compact.within(window)` — over the window, the model sees the system prompt, the task, a summary (made by the
  same model, stable until the next compaction) and the latest turns; its law: invisible in what the agent does.
- `Journal.recording` — each turn and act written (the CLI: ~/.okay-agent/journals/*.jsonl); `okay-agent --replay
  <journal>` runs it again with no model and no world, strictly; its law: the same acts, the same end.

- MCP servers with no setting: the project's `.mcp.json` (Claude Code's file), and **symdex** where the project has an
  index (SemanticDB, `*.scip`) — its tools (definition, references, implementations, …) the agent's, read-only.
  symdex itself installed and kept up to date by okay-agent: its manifest on GitHub Pages
  (https://okay-effects.github.io/symdex/latest.json) read at most once a day, a newer release downloaded, checked
  (SHA-256), unpacked into ~/.symdex/<version> (where sbt-symdex puts it too); offline, the installed one;
  `OKAY_AGENT_NO_INSTALL=1` not at all; one on PATH used as it is. In an sbt project without it, the tool `symdex_setup` sets it up (its plugin, `sbt symdexIndex
  symdexMcp`); the next run has its tools. A grep for a symbol that finds nothing points to `references`.

- `--forecast N` — before a call that is not a read, what comes after it forecast: the same program run on from the
  same conversation (the model the real one, its cache shared), N turns at most, the calls imagined done (reads real).
  Asked only when the call or anything ahead is risky (a commit, a push, `rm -rf`, a publish, `curl | sh` …), the
  forecast in the question:

  ```
  write — edit {"path":"hello.py", …}
    forecast: then bash python3 -c "…", git_commit Add answer(); then done (3 turns); ⚠ git_commit … (not to be undone)
    allow? [y/N]
  ```

  Laws: it touches nothing (the world's acts the same with it as without), its requests extend the conversation, a run
  with forecasts replays from its journal. It costs model time: on Qwen3.6-35B, ~30 s a forecast of 2–3 turns.
  `--futures N`: the forecast a tree of N nodes (okay-scala's `Cofree`), branching as commands pass or fail — "⚠ in 2
  of 3 futures: git_commit …"; wider, so shallower for the same time: for irreversible steps.

- `--stuck N` (3 by default; 0 off) — a coeffect: each call decided by the history behind it (okay-scala's
  `Coeffects.aroundHistory`). After N calls failed in a row, a call that is not a read is asked first:

  ```
  ✗ bash {"command":"./build.sh"}  /bin/sh: ./build.sh: No such file or directory (exit 127)   ×3
  3 calls failed in a row — go on with bash {"command":"./build.sh"}? [y/N]
  ```

  A person's refusals (the gate's, the forecast's) are not the agent's failures. Laws: no call but a read reaches the
  world stuck unless the person said yes to it (300 runs of a hostile model in a failing world); nobody asked when
  nothing fails; a run replays from its journal — kept innermost, so every refusal is in it.

## Surfaces

- `okay-agent acp` — an ACP agent over stdio (Zed, okay-remote: "okay-agent · <model>" on its New screen, the phone
  approving): its files and commands through the client, so the client's gate weighs each.
- `okay-agent serve [--port 8091] [--forecast N]` — an AG-UI server (`POST /agent`), any AG-UI client a front end: a
  call to be asked about ends the run with an interrupt, the program waits for it alive, the next run's `resume`
  answers it. okay-remote serves every session the same way (`POST /agui`).
