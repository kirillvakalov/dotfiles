#!/usr/bin/env zsh
# Based on https://github.com/willhbr/dotfiles/blob/main/bin/show-tmux-popup.sh

session="_popup"

if ! tmux has -t "$session" 2> /dev/null; then
  session_id="$(tmux new-session -c '#{pane_current_path}' -dP -s "$session" -F '#{session_id}')"
  tmux set-option -s -t "$session_id" status off
  tmux set-option -s -t "$session_id" prefix None
  session="$session_id"
fi

exec tmux attach -t "$session" > /dev/null
