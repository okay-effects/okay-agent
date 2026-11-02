# AGENTS.md — okay-agent

Read before anything else; then `specs/agent.md`. A change of design is a change of the spec first.

- The agent is ONE program over effects (`Llm`, `Tools`, `Human`, okay-scala's std); every world is handlers, every
  guarantee an interceptor (a handler transformer). No second representation of the agent.
- Every guarantee has a law, tested as a property over states reached by real transitions — never states built by hand.
- No replay for multi-shot continuations (the user's rule): a continuation is a value (okay-scala's machine).
- Lines at most 120 characters. Commits: plain messages, no attribution trailers. Repo text in English.
