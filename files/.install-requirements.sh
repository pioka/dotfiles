#!/bin/zsh

mkdir -p ~/.local/bin

# zsh-auto-suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# git-delta
curl -L https://github.com/dandavison/delta/releases/download/0.12.1/delta-0.12.1-x86_64-unknown-linux-gnu.tar.gz -o ~/.local/bin/delta.tar.gz
tar -xzf ~/.local/bin/delta.tar.gz --wildcards --strip-components=1 -C ~/.local/bin '**/delta' && rm ~/.local/bin/delta.tar.gz

# neovim
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b v0.8.1
source ~/.asdf/asdf.sh

# nodejs (for coc.nvim)
asdf plugin-add nodejs
asdf install nodejs lts
asdf global nodejs lts

