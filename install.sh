#!/bin/sh

TARGET_FILES=`find ./files -type f`

for src in $TARGET_FILES; do
  dest="$HOME/`echo $src | sed "s/^.\/files\///" `"
  mkdir -p `dirname $dest`
  cp $src $dest
  echo "$src -> $dest"
done