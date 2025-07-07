#!/usr/bin/env zsh

# Get selection fg and bg colors from ghostty config and store them as vars
read -r SELECTION_FOREGROUND SELECTION_BACKGROUND <<<$(
  ghostty +show-config |
    awk -F' *= *' '
      /^selection-foreground/  { fg = $2 }
      /^selection-background/  { bg = $2 }
      END { print fg, bg }      # print both on one line
    '
)

# Patch tmux config file
tmux_style="fg='${SELECTION_FOREGROUND}',bg='${SELECTION_BACKGROUND}'"
sed -E -i '' \
  -e "s/^set -g mode-style.*/set -g mode-style ${tmux_style}/" \
  -e "s/^set -g message-style.*/set -g message-style ${tmux_style}/" \
  config/tmux/tmux.conf
# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf

# Patch lazygit config file
yq -i \
  ".gui.theme.selectedLineBgColor = [\"${SELECTION_BACKGROUND}\"]" \
  config/lazygit/config.yml
