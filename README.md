# My dotfiles 🎛🙈

## Setup

1. Install [Homebrew](https://brew.sh)
2. Install **GnuPG** `brew install gnupg`
3. Import GPG private key

   1. `gpg --import secret.gpg`
   2. `gpg --edit-key 7E0165C9FD2578F3`
   3. <code>_gpg>_ trust</code>
   4. <code>_Your decision?_ 5</code>
   5. <code>_gpg>_ quit</code>
   6. Verify that key have **ultimate** trust level:
      1. `gpg --list-secret-keys --keyid-format=long`
      2. `gpg --list-keys --keyid-format=long`

4. Setup **GitHub CLI**
   1. `brew install gh`
   2. `gh auth login`
5. `gh repo clone kirillvakalov/dotfiles`
6. `brew bundle`
7. `./set-fish-as-default-shell.sh`
8. `./install-volta.sh`
9. `stow git`
10. `stow fish`
11. `stow terminal`
12. `stow starship`

## Appearance 💅

### Fonts

[Cascadia Code](https://github.com/microsoft/cascadia-code/releases)

### Terminal

[Dracula theme](https://draculatheme.com/terminal)

### Fish

[Dracula theme](https://draculatheme.com/fish). Install with `fish_config theme choose dracula`
