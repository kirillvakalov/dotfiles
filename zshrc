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

# Quote pasted URLs automatically (https://github.com/zsh-users/zsh/blob/master/Functions/Zle/bracketed-paste-url-magic)
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

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
