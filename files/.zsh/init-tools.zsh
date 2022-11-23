#!/bin/zsh

mkdir -p ~/.local/bin

# zsh-auto-suggestions
if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# asdf
if [ ! -f ~/.asdf/asdf.sh ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b v0.8.1
fi
source ~/.asdf/asdf.sh

# git-delta
if [ ! -x ~/.local/bin/delta ]; then
  curl -L https://github.com/dandavison/delta/releases/download/0.12.1/delta-0.12.1-x86_64-unknown-linux-gnu.tar.gz -o ~/.local/bin/delta.tar.gz
  tar -xzf ~/.local/bin/delta.tar.gz --wildcards --strip-components=1 -C ~/.local/bin '**/delta' && rm ~/.local/bin/delta.tar.gz
fi


# gitconfig.local 
if [ ! -f ~/.gitconfig.local ]; then
  cat << EOS > ~/.gitconfig.local
[user]
	email = ''
	name = ''
EOS
fi

