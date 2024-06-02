# Turn off autocomplete beep (to turn off all beeps use: unsetopt beep)
unsetopt list_beep

# brew shell completion (https://docs.brew.sh/Shell-Completion)
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Plugins
if [[ ! -e ~/.zsh/zsh-syntax-highlighting ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi
if [[ ! -e ~/.zsh/zsh-autosuggestions ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
if [[ ! -e ~/.zsh/pure ]]; then
  git clone --depth 1 https://github.com/sindresorhus/pure ~/.zsh/pure
fi

function zsh-update-plugins() {
  rm -rf ~/.zsh && exec zsh
}

# Syntax highlighting plugin must be loaded before autosuggestions
# Reference: https://github.com/sorin-ionescu/prezto/tree/master/modules/syntax-highlighting#readme
# Syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Shift+Tab - Accepts the current suggestion
bindkey '^[[Z' autosuggest-accept

# Prompt (https://github.com/sindresorhus/pure?tab=readme-ov-file#example)
fpath+=(~/.zsh/pure)
autoload -U promptinit; promptinit
zstyle :prompt:pure:git:stash show yes
prompt pure

# fzf (https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration)
source <(fzf --zsh)

# Atuin shell history (https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin)
eval "$(atuin init zsh)"

# Allow local customizations in the ~/.zshrc_local file
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi
