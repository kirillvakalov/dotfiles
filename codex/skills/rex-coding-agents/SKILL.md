---
name: rex-coding-agents
description: >-
  Launch coding agents such as Codex or OpenCode in an interactive Rex pane.
---

# Launch coding agents in Rex

Open, start, run, or launch coding agents in a new interactive Rex pane, even
when Rex is not mentioned. Use tabs, background processes, or headless/one-shot
mode only when explicitly requested.

For shell aliases such as `oc`, create a pane without a command, confirm its
shell prompt, then use `rex send` and `rex send-key` to type the alias and press
Enter. Commands passed after `--` skip interactive shell config and its aliases.
