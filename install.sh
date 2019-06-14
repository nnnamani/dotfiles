#!/bin/sh

for name in $(find `pwd` -type d -name .git -prune -o -name ".*" -print)
do
    if [ -x ~/$(basename $name) ]; then
        cp ~/$(basename $name) ~/$(basename $name).old
    fi
    ln -sfv $name ~/$(basename $name)
done
