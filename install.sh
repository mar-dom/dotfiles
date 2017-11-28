#!/bin/bash

echo "[*] Starting customization!"

echo "[*] Installing dependencies... (will ask for sudo password)"

# install dependencies
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
if [ $distro = "Debian" ]; then
    sudo apt-get install -y -qq htop wget curl git zsh tmux vim-nox fortune > /dev/null
    if [ ! $? -eq 0 ]; then
        echo "Error: could not install dependencies!"
        exit -1
    fi
else
    echo "  [!] Please install htop, wget, curl, git, zsh, tmux, vim and fortune!"
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
sudo chsh -s $(which zsh) $USER

echo "[*] Done!"
