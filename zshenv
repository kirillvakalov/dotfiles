export XDG_CONFIG_HOME=$HOME/.config

# GNU LS_COLORS from dircolors https://man.archlinux.org/man/dircolors.1.en
# converted to BSD LSCOLORS with https://geoff.greer.fm/lscolors/
export LSCOLORS="ExGxFxdaCxDaDahbadacec"

export EDITOR="nvim"
export VISUAL="nvim"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgreprc"

# Colima + Testcontainers setup
export COLIMA_HOME="$HOME/.colima"
export DOCKER_HOST="unix://$COLIMA_HOME/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
