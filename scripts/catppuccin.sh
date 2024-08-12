#!/usr/bin/env zsh

# Bat
mkdir -p "$(bat --config-dir)/themes"
wget -nc -O "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
bat cache --build

# Git Delta
mkdir -p "$HOME/.config/delta/themes"
wget -nc -O "$HOME/.config/delta/themes/catppuccin.gitconfig" https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig

# Lazygit
mkdir -p "$HOME/.config/lazygit/themes"
wget -nc -O "$HOME/.config/lazygit/themes/catppuccin-latte-blue.yml" https://raw.githubusercontent.com/catppuccin/lazygit/main/themes-mergable/latte/blue.yml
source ~/.zshrc
