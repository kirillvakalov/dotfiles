---
name: rex-coding-agents
description: >-
  Launch coding agents such as Codex or OpenCode in an interactive Rex pane.
---

# Launch coding agents in Rex

Open, start or launch coding agents such as Codex, Pi or OpenCode in a new
interactive Rex pane, even when Rex is not mentioned. Use tabs, background
processes, or headless/one-shot mode only when explicitly requested.

For shell aliases such as `oc`, create a pane without a command, confirm its
shell prompt, then use `rex send` and `rex send-key` to type the alias and
press Enter. Because commands passed after `--` to `rex run` run in login
shell's environment and skip interactive shell config and its aliases.
