#!/usr/bin/env zsh

# Bat
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
curl --remote-name-all https://raw.githubusercontent.com/rose-pine/tm-theme/main/dist/themes/rose-pine{,-dawn,-moon}.tmTheme
bat cache --build

# Lazygit
source ~/.zshrc
