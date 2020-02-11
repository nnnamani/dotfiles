#!/bin/bash

dotfiles=(.emacs.d .lem .tmux.conf .vimrc .zshrc .git_templates)

#for name in $(find `pwd` -type d -name .git -prune -o -name ".*" -print)
for name in ${dotfiles[@]}
do
	ln -sfv $(pwd)/$name ~
done
