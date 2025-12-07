ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#system-clipboard
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
# https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#command-line-initial-mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#initialization-mode
ZVM_INIT_MODE=sourcing

# https://github.com/agkozak/agkozak-zsh-prompt?tab=readme-ov-file
AGKOZAK_USER_HOST_DISPLAY=0
AGKOZAK_COLORS_BRANCH_STATUS=242
AGKOZAK_BLANK_LINES=1

# Configure zsh-syntax-highlighting and zsh-autosuggestions
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Quote pasted URLs automatically (https://github.com/zsh-users/zsh/blob/master/Functions/Zle/bracketed-paste-url-magic)
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# Shell history search with fzf. Previously I have used atuin and
# switched because it has very bad fuzzy matching compared to fzf.
# https://gist.github.com/mattmc3/c490d01751d6eb80aa541711ab1d54b1
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS # 'cd ' and 'cd' will be saved as one command in history

# fzf (https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration)
source <(fzf --zsh)

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
alias ls="ls --color=auto"
alias lf="lfcd"
alias lz="lazygit"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"

# PATH
# This one is needed so 'gke-gcloud-auth-plugin' can be found
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/cloud-sql-proxy:$PATH"
