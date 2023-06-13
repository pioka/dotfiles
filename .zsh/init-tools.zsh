#!/bin/zsh

V_ASDF='v0.11.3'
V_DELTA='0.14.0'
V_NVIM='stable'

mkdir -p ~/.local/bin

# zsh-auto-suggestions
if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# asdf
if [ ! -f ~/.asdf/asdf.sh ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b ${V_ASDF}
fi
source ~/.asdf/asdf.sh

# neovim(via asdf)
if ! nvim -v > /dev/null; then
  asdf plugin-add neovim
  asdf install neovim ${V_NVIM}
  asdf global neovim ${V_NVIM}
fi

# delta(via asdf)
if ! delta -V > /dev/null; then
  asdf plugin-add delta
  asdf install delta ${V_DELTA}
  asdf global delta ${V_DELTA}
fi

# local gitconfig
if [ ! -f ~/.gitconfig.local ]; then
  cat << EOS > ~/.gitconfig.local
[user]
	email = ''
	name = ''
EOS
fi

if [ -n "$TMUX_AUTO_LAUNCH" ]; then t; fi
