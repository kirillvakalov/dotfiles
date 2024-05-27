# Starship prompt (https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship)
eval "$(starship init zsh)"

# Atuin shell history (https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin)
eval "$(atuin init zsh)"

# Allow local customizations in the ~/.zshrc_local file
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi
