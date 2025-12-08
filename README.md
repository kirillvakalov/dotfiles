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

### Setup Android emulator

```sh
# For the system Java wrappers to find openjdk-21 JDK, symlink it with
sudo ln -sfn $HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk

# Install all required dependencies
sdkmanager "platform-tools" "emulator"
sdkmanager "platforms;android-34" "system-images;android-34;google_apis;arm64-v8a"

# Create device
avdmanager create avd --name "<name>" --package "system-images;android-34;google_apis;arm64-v8a" -d pixel_6 --force
```

### Run Android emulator

```sh
emulator -avd "<name>" -no-snapshot-load
```
