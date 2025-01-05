ZIM_HOME=~/.cache/zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Configure zsh-syntax-highlighting and zsh-autosuggestions
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Powerlevel10k
source ~/.p10k.zsh

# Vi Mode
bindkey -v

# 10ms delay for key sequences
export KEYTIMEOUT=1

# Bind 'v' in Vi NORMAL mode to edit command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


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


# Case-insensitive (all), partial-word, and then substring completion (https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#L87-L88)
zstyle ':completion:' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:upper:]}={[:lower:]}' 'r:|[._-]= r:|=' 'l:|= r:|=*'
unsetopt CASE_GLOB

# Show hidden files and folders on completion (https://unix.stackexchange.com/a/308322)
_comp_options+=(globdots)


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
