# Starship prompt (https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship)
eval "$(starship init zsh)"

# Allow local customizations in the ~/.zshrc_local file
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi
