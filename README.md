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
4. Install GnuPG and import GPG key from _iCloud Drive/Backup/gpg key_
   1. `brew install gnupg`
   2. `gpg --import public.gpg.asc`
   3. `gpg --import private.gpg.asc`
   4. `gpg --import-ownertrust ownertrust.txt`
   5. Verify that key have **ultimate** trust level:

      `gpg --list-secret-keys --keyid-format=long`

5. `brew install git gh`
6. `gh auth login` (select SSH for 'What is your preferred protocol for Git operations on this host?')
7. `gh repo clone kirillvakalov/dotfiles`
8. `cd dotfiles`
9. `brew bundle`
10. `rm ~/.gitconfig`
11. `./install`
12. Workaround for [mission control showing too small windows](https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control) when using AeroSpace

    `defaults write com.apple.dock expose-group-apps -bool true && killall Dock`

### Setup Android emulator

```sh
# For the system Java wrappers to find this JDK, symlink it with
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# Install all required dependencies
sdkmanager "platform-tools" "emulator"
sdkmanager "build-tools;34.0.0" "platforms;android-34" "system-images;android-34;google_apis;arm64-v8a"

# Create Pixel 6 device
avdmanager create avd --name "<name>" --package "system-images;android-34;google_apis;arm64-v8a" -d pixel_6 --force
```

### Run Android emulator

```sh
emulator -avd "<name>" -no-snapshot-load
```
