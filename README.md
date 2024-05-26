# dotfiles 🧑‍🔧

## Setup

1. Import SSH keys (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)

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

2. Copy gitconfig and gitignore.global to home directory as .gitconfig and .gitignore.global
3. Install [Homebrew](https://brew.sh)
4. Install **GnuPG** and import GPG keys

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
10. `./install`
