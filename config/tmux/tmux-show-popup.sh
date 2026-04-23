#!/usr/bin/env zsh
# Based on https://github.com/willhbr/dotfiles/blob/main/bin/show-tmux-popup.sh

if ! tmux has -t _popup 2> /dev/null; then
  tmux new-session -d -s _popup -c '#{pane_current_path}'
  tmux set -s -t _popup status off
  tmux set -s -t _popup prefix None
fi

exec tmux attach -t _popup > /dev/null
