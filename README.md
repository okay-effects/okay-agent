# okay-agent

A coding agent as **one program over effects** — the model (okay-llm's `Llm`), its tools, a person — every world
handlers, every guarantee an interceptor with its law, tested as a property. Local models first: a short prompt
(~0.9k tokens to start, against Claude Code's ~14k), requests that only ever append (okay-mlx's prefix cache keeps
them), and every step ours to gate and record. The design: [`specs/agent.md`](specs/agent.md).

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
  index (SemanticDB, `*.scip`) and symdex is installed — its tools (definition, references, implementations, …) the
  agent's, read-only. In an sbt project without it, the tool `symdex_setup` sets it up (its plugin, `sbt symdexIndex
  symdexMcp`); the next run has its tools. A grep for a symbol that finds nothing points to `references`.

Next: okay-agent over ACP in okay-remote; an AG-UI server; the forecast.
