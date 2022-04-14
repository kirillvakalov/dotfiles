set fish_greeting

set -x EDITOR "code -w"
set -x HOMEBREW_INSTALL_BADGE "🐣"
set -x BAT_THEME "Dracula"

set -x VOLTA_HOME "$HOME/.volta"
fish_add_path "$VOLTA_HOME/bin"

if status is-interactive
  alias ls="exa"
  alias cat="bat"

  starship init fish | source
end
