export XDG_CONFIG_HOME=$HOME/.config

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
