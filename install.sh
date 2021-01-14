#!/bin/bash

dotfiles=(.emacs.d .lem .tmux.conf .vimrc .zshrc .git_templates)

for name in ${dotfiles[@]}
do
	ln -sfv $(pwd)/$name ~
done

dotconfigs=(i3)
for name in ${dotconfigs[@]}
do
	ln -sfv $(pwd)/$name ~/.config
done
