#!/bin/bash

echo "[*] Starting customization!"

echo "[*] Installing dependencies... (will ask for sudo password)"

# install dependencies
sudo apt-get install -y -qq htop wget curl git zsh tmux vim-nox fortune > /dev/null

if [ ! $? -eq 0 ]; then
    echo "Error: could not install dependencies!"
    exit -1
fi

echo "[*] Pulling the git repo"
# pull the dotfiles
git clone https://github.com/mdomazet/dotfiles .dotfiles --recursive
if [ ! $? -eq 0 ]; then
    echo "Error: could not pull the repo!"
    exit -1
fi

echo "[*] Linking files..."
# install the dotfiles
~/.dotfiles/configure.sh

echo "[*] Changing shell to zsh..."
chsh -s $(which zsh)

echo "[*] Done!"
