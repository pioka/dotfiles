#!/bin/sh

FILES=`cat << EOS
.gitconfig
.vimrc
.zshrc
EOS
`

DIST_DIR=`pwd`/.dist

mkdir -p $DIST_DIR

for f in $FILES; do
  cp $f $DIST_DIR/$f
  ln -sf $DIST_DIR/$f $HOME/$f
done
