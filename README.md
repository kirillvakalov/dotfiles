# My dotfiles 🎛🙈

## Setup

1. Install [Homebrew](https://brew.sh)
2. Install **GnuPG** `brew install gnupg`
3. Import GPG public and private keys

   1. `gpg --import public.gpg.asc`
   2. `gpg --import private.gpg.asc`
   3. `gpg --import-ownertrust ownertrust.txt`
   4. Verify that key have **ultimate** trust level: 

      `gpg --list-secret-keys --keyid-format=long`

4. Import SSH keys

```sh
mkdir -p ~/.ssh
cat << EOF > ~/.ssh/config
Host github.com
   AddKeysToAgent yes
   IdentityFile ~/.ssh/id_ed25519
EOF
cp id_ed25519 ~/.ssh/id_ed25519
cp id_ed25519.pub ~/.ssh/id_ed25519.pub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

5. Setup **GitHub CLI**
   1. `brew install gh`
   2. `gh auth login --web`
   3. `gh config set git_protocol ssh --host github.com`
5. `gh repo clone kirillvakalov/dotfiles`
6. `brew bundle`
7. `./set-fish-as-default-shell.sh`
8. `./pnpm.sh`
9. `stow git`
10. `stow fish`
11. `stow terminal`
12. `stow starship`

## Appearance 💅

### Fonts

[Download Cascadia Code](https://github.com/microsoft/cascadia-code/releases)

### Terminal

[Download Dracula theme](https://draculatheme.com/terminal)

### Fish

Run `fish_config` and choose **Dracula** as color scheme.
