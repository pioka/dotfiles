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

git clone https://github.com/pioka/dotfiles.git
```