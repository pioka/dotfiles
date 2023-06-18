#!/bin/zsh

# local bin dir
mkdir -p ~/.local/bin

# zplug
if [ ! -f ~/.zplug/init.zsh ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", from:github
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "plugins/git-auto-fetch", from:oh-my-zsh
zplug "plugins/timer", from:oh-my-zsh
zplug check || zplug install
zplug load



# asdf
if [ ! -f ~/.asdf/asdf.sh ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b 'v0.11.3'
fi
source ~/.asdf/asdf.sh




# generate default configs
if [ ! -f ~/.tool-versions ]; then
  cat << EOS > ~/.tool-versions
neovim stable
delta 0.14.0
EOS
fi

if [ ! -f ~/.gitconfig.local ]; then
  cat << EOS > ~/.gitconfig.local
[user]
	email = ''
	name = ''
EOS
fi
