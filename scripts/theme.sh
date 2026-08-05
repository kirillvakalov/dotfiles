#!/usr/bin/env zsh

# Get the selection background color from the Ghostty config.
SELECTION_BACKGROUND=$(
  ghostty +show-config |
    awk -F' *= *' '
      /^selection-background/ { print $2 }
    '
)

# Patch lazygit config file
sed -E -i '' \
  "/^    selectedLineBgColor:/{n;s|^(      - ').*(')$|\1${SELECTION_BACKGROUND}\2|;}" \
  config/lazygit/config.yml
