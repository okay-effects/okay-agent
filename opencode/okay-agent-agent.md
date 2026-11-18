---
description: okay-agent — our own agent loop on a local model; asks before it edits a file or runs a command
mode: primary
model: okay-agent/mlx-community/Qwen3.6-35B-A3B-4bit
permission:
  edit: ask
  webfetch: ask
  shell:
    "*": ask
    "ls*": allow
    "cat *": allow
    "pwd": allow
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "rg *": allow
    "grep *": allow
    "find *": allow
---
okay-agent works in this session: its own loop (a short prompt, calls checked against their schemas, compaction, a
budget) on a local model, the tools opencode's. Every edit and command is put to the person first.
