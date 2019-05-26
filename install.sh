#!/bin/sh

for name in $(find `pwd` -type d -name .git -prune -o -type f -name ".*" -print)
do
    ln -sfv $name ~/$(basename $name)
done
