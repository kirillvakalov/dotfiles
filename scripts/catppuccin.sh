#!/usr/bin/env zsh

# Bat
mkdir -p "$(bat --config-dir)/themes"
wget -nc -O "$(bat --config-dir)/themes/catppuccin-mocha.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

# Git Delta
mkdir -p "$HOME/.config/delta/themes"
wget -nc -O "$HOME/.config/delta/themes/catppuccin.gitconfig" https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig

# Lazygit
mkdir -p "$HOME/.config/lazygit/themes"
wget -nc -O "$HOME/.config/lazygit/themes/catppuccin-mocha-blue.yml" https://raw.githubusercontent.com/catppuccin/lazygit/main/themes-mergable/mocha/blue.yml
source ~/.zshrc
