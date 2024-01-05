#!/bin/zsh

# local bin dir
mkdir -p ~/.local/bin

# zsh plugins
function _zsh_plug_add() {
  plug_repo="https://github.com/$1.git"
  plug_dir="$HOME/.zsh/plugins/$1"
  plug_match="${plug_dir}/${2:-*.zsh}"
  test -d "$plug_dir" || git clone "$plug_repo" "$plug_dir"
  source $(ls $~plug_match | head -1) || echo "$plug_match match not found"
}

_zsh_plug_add "zsh-users/zsh-syntax-highlighting"
_zsh_plug_add "zsh-users/zsh-autosuggestions"
_zsh_plug_add "ohmyzsh/ohmyzsh" "plugins/git-auto-fetch/*.zsh"
_zsh_plug_add "ohmyzsh/ohmyzsh" "plugins/timer/*.zsh"



# asdf
if [ ! -f ~/.asdf/asdf.sh ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf -b 'v0.13.1'
fi
source ~/.asdf/asdf.sh




# generate default configs
if [ ! -f ~/.tool-versions ]; then
  cat << EOS > ~/.tool-versions
neovim stable
delta 0.14.0
EOS
  cut -d' ' -f1 ~/.tool-versions | xargs -I{} asdf plugin-add {}
fi

if [ ! -f ~/.gitconfig.local ]; then
  cat << EOS > ~/.gitconfig.local
[user]
	email = ''
	name = ''
EOS
fi
