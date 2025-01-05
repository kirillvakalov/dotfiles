
# Vi Mode
bindkey -v

# 10ms delay for key sequences
export KEYTIMEOUT=1

# Bind 'v' in Vi NORMAL mode to edit command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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
if [[ ! -d ~/.zsh/powerlevel10k ]]; then
  git clone --depth 1 https://github.com/romkatv/powerlevel10k ~/.zsh/powerlevel10k
fi

function zsh-update-plugins() {
  rm -rf ~/.zsh && exec zsh
}


# Turn off all beeps (https://blog.vghaisas.com/zsh-beep-sound/),
# also (https://github.com/junegunn/fzf/issues/3864#issuecomment-2168457090)
unsetopt BEEP

# Quote pasted URLs automatically (https://github.com/zsh-users/zsh/blob/master/Functions/Zle/bracketed-paste-url-magic)
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# Standard style used by default for 'list-colors' (https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#L47)
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:"


# Homebrew shell completion (https://docs.brew.sh/Shell-Completion)
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi


# fzf (https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration)
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--ansi --tmux"


# Completions
# Use fzf for zsh completion selection menu
# fzf-tab needs to be loaded before autosuggestions (ref: https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#install)
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Case-insensitive (all), partial-word, and then substring completion (https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#L87-L88)
zstyle ':completion:' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:upper:]}={[:lower:]}' 'r:|[._-]= r:|=' 'l:|= r:|=*'
unsetopt CASE_GLOB

# Show hidden files and folders on completion (https://unix.stackexchange.com/a/308322)
_comp_options+=(globdots)


# Syntax highlighting
# Syntax highlighting plugin must be loaded before autosuggestions
# (ref: https://github.com/sorin-ionescu/prezto/tree/master/modules/syntax-highlighting#readme)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md#highlighter-independent-settings
ZSH_HIGHLIGHT_MAXLENGTH=512


# Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Press Shift+Tab to accept the current suggestion
bindkey '^[[Z' autosuggest-accept


# Powerlevel 10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Atuin shell history (https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin)
eval "$(atuin init zsh)"


# zoxide (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
eval "$(zoxide init zsh)"


# Node.js version manager
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --corepack-enabled --log-level=quiet --shell zsh)"


# Change working dir in shell to last dir in lf on exit
# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}


# Aliases
alias cat="bat --plain"
alias ls="eza"
alias lf="lfcd"
alias lz="lazygit"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"


# PATH
# This one is needed so 'gke-gcloud-auth-plugin' can be found
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/cloud-sql-proxy:$PATH"
