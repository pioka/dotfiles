# dotfiles
dotfiles

## 初回セットアップ
```sh
# change shell to zsh
chsh -s /bin/zsh

# install FUSE
## Ubuntu
sudo apt install -y fuse
## CentOS
sudo yum install -y epel-release && sudo yum install -y fuse-sshfs

# install nodejs
asdf plugin-add nodejs && asdf install nodejs lts

# Install neovim
mkdir -p ~/.local/bin
curl -sL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim
```
