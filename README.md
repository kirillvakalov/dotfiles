# My dotfiles 🎛

## Setup on fresh macOS install

1. Import GPG private key

   1. `gpg --import secret.gpg`
   2. `gpg --edit-key 7E0165C9FD2578F3`
   3. <code>_gpg>_ trust</code>
   4. <code>_Your decision?_ 5</code>
   5. <code>_gpg>_ quit</code>
   6. Verify that key have **ultimate** trust level:
      1. `gpg --list-secret-keys --keyid-format=long`
      2. `gpg --list-keys --keyid-format=long`

2. Install [Homebrew](https://brew.sh/)
3. Setup **GitHub CLI**
   1. `brew install gh`
   2. `gh auth login`
4. Clone this repo
5. `brew bundle`
6. `./set-fish-as-default-shell.sh`
7. `./install-volta.sh`
8. `stow git`
9. `stow fish`
10. `stow terminal`
11. `stow starship`
