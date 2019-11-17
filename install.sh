#!/bin/bash

dotfiles=(.emacs.d .lem .tmux.conf .vimrc .zshrc)

#for name in $(find `pwd` -type d -name .git -prune -o -name ".*" -print)
for name in ${dotfiles[@]}
do
	ln -sfv $(find $(pwd) -name $name) ~
done
