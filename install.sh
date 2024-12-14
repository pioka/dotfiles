#!/bin/sh

TARGET_FILES=$(find . -type f \
  -not -path './.git/*' \
  -not -path './win/*' \
  -not -path './install.sh' \
  -not -path './win-install.ps1' \
  -not -path './README.md')

for src in $TARGET_FILES; do
  dest=$(echo $src | sed "s|^./|$HOME/|" )
  mkdir -p $(dirname $dest)
  cp $src $dest
  echo "$src -> $dest"
done
