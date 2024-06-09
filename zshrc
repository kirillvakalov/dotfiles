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
if [[ ! -d ~/.zsh/fzf-tab ]]; then
  git clone --depth 1 https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
fi
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi
if [[ ! -d ~/.zsh/zsh-autosuggestions ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
if [[ ! -d ~/.zsh/pure ]]; then
  git clone --depth 1 https://github.com/sindresorhus/pure ~/.zsh/pure
fi

function zsh-update-plugins() {
  rm -rf ~/.zsh && exec zsh
}

# fzf (https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration)
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--ansi"

# Use fzf for zsh completion selection menu
# fzf-tab needs to be loaded before autosuggestions (ref: https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#install)
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'

# Syntax highlighting plugin must be loaded before autosuggestions
# (ref: https://github.com/sorin-ionescu/prezto/tree/master/modules/syntax-highlighting#readme)
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

# Atuin shell history (https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin)
eval "$(atuin init zsh)"

# zoxide (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
eval "$(zoxide init zsh)"

# PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/cloud-sql-proxy:$PATH"
