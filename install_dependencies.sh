#!/bin/sh

function say_not_found_command() {
    echo "${1} is not found."
    echo "Install ${1} ..."
}

function install_with_brew() {
    if ! [ -x "$(command -v ${1})" ]; then
        say_not_found_command ${1}
        brew install ${1}
    fi
}

if [ "$(uname)" == 'Darwin' ]; then
    if ! [ -x "$(command -v brew)" ]; then
        say_not_found_command brew
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew update

    install_with_brew zsh
    #TODO: install_with_brew zplug
    install_with_brew ghq
    install_with_brew hub
fi
