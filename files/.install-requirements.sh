#!/bin/zsh

mkdir -p ~/.local/bin

# zsh-auto-suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b v0.8.1
source ~/.asdf/asdf.sh

# neovim
if [ "`uname -s`" = "Linux" ]; then
  curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
  chmod +x ~/.local/bin/nvim
fi

# nodejs (for coc.nvim)
asdf plugin-add nodejs
asdf install nodejs lts
asdf global nodejs lts

