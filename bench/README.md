# Real tasks, three agents

`tasks.tsv`: ten tasks in this machine's repositories (okay-guard, okay-llm, okay-agent, okay-scala, okay-remote,
okay-mlx, okay-simple), each with its check — a test run, a grep, the answer's words. Tasks 2 and 6 start broken (a
bug put in first). Each agent on each task in a fresh clone, 20 minutes at most, the same model for all
(Qwen3.6-35B-A3B-4bit through okay-mlx's gateway): okay-agent (`--yes`), opencode (`opencode run`, every tool
allowed), Claude Code (`claude -p` on the gateway's Anthropic API). `history.tsv` keeps every run, appended to.

2026-11-03:

| agent | solved | median | total | median turns |
|---|---|---|---|---|
| okay-agent | 10 of 10 (one out of turns: 9) | 135 s | 2010 s | 7.5 |
| opencode | 9 of 10 (1: timed out) | 139 s | 2778 s | — |
| Claude Code | 10 of 10 | 230 s | 2591 s | 11.5 |

Task 9 was put in the wrong repository (the default policy is okay-remote's, not okay-guard's): opencode and Claude
answered from what was there; okay-agent searched for 40 turns. Seen there: the model asked `read` for line ranges
(`start_line`, `end_line`), which it does not take — the whole file each time.
