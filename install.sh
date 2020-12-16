#!/bin/sh

FILES=`cat << EOS
.gitconfig
.npmrc
.vimrc
.zshenv
.zshrc
EOS
`

for f in $FILES; do
  ln -sf `pwd`/$f $HOME/$f
done