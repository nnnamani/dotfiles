#!/bin/sh

for name in $(find `pwd` -type d -name .git -prune -o -name ".*" -print)
do
    if [ -x ~/$(basename $name) ]; then
        cp ~/$(basename $name) ~/$(basename $name).old
    fi

    if [ -d $name ]; then
	ln -sfv $name ~
    else
	ln -sfv $name ~/$(basename $name)
    fi
done
