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
sed -E -i '' \
  "s/^set -g mode-style.*/set -g mode-style fg='${SELECTION_FOREGROUND}',bg='${SELECTION_BACKGROUND}'/" \
  config/tmux/tmux.conf
# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf

# Patch lazygit config file
yq -i \
  ".gui.theme.selectedLineBgColor = [\"${SELECTION_BACKGROUND}\"]" \
  config/lazygit/config.yml
