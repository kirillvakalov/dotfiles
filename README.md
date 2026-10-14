# dotfiles 🧑‍🔧

## Setup

1. Import SSH key for git from _iCloud Drive/Backup/ssh key_ and add it to
   [ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)

```sh
eval "$(ssh-agent -s)"
mkdir -p ~/.ssh
cp id_ed25519 ~/.ssh/id_ed25519
cp id_ed25519.pub ~/.ssh/id_ed25519.pub
cat << EOF > ~/.ssh/config
Host github.com
   AddKeysToAgent yes
   IdentityFile ~/.ssh/id_ed25519
EOF
ssh-add ~/.ssh/id_ed25519
```

2. Copy [gitconfig](https://github.com/kirillvakalov/dotfiles/blob/main/gitconfig) to home directory as _.gitconfig_
3. Install [Homebrew](https://brew.sh)
4. Run:

```sh
brew install git
git clone https://github.com/kirillvakalov/dotfiles.git
cd dotfiles
brew bundle
```

5. Run to install Krew kubectl plugins and JADX AI MCP (https://github.com/zinja-coder/jadx-ai-mcp):

```sh
kubectl krew upgrade && kubectl krew install ctx cnpg
jadx plugins --install "github:zinja-coder:jadx-ai-mcp"
uv tool install git+https://github.com/zinja-coder/jadx-mcp-server
```

6. Install dotfiles:

```sh
./install
```

### Tips

#### Workaround for [mission control showing too small windows](https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control) when using window manager like Rift

```sh
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

#### To close Google Chrome instantly on pressing _⌘Q_

Select _Chrome_ in the menu bar and select to un-check _Warn before Quitting (⌘Q)_

#### Show Emoji & Symbols on pressing _fn (globe) key_

Go to System Settings -> Keyboard -> Press _globe key_ to -> Show Emoji & Symbols
