#!/bin/bash

# install dependencies
sudo apt-get install -y -qq htop wget curl git zsh tmux vim-nox fortune > /dev/null

if [ ! $? -eq 0 ]; then
    echo "Error: could not install dependencies!"
    exit -1
fi

# pull the dotfiles
git clone https://github.com/mdomazet/dotfiles .dotfiles --recursive

# install the dotfiles
. /install.sh

