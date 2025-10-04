export XDG_CONFIG_HOME=$HOME/.config

# GNU LS_COLORS from dircolors https://man.archlinux.org/man/dircolors.1.en
# converted to BSD LSCOLORS with https://geoff.greer.fm/lscolors/
export LSCOLORS="ExGxFxdaCxDaDahbadacec"

export EDITOR="nvim"
export VISUAL="nvim"

# Used by bat and git delta pager
export BAT_THEME="base16"
export BAT_PAGER=""

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgreprc"

# Colima + Testcontainers setup
export DOCKER_HOST=unix://${HOME}/.config/colima/default/docker.sock
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
