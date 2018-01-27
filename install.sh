#!/bin/bash
# set filetype=sh

echo "Antigen install..."
git clone https://github.com/zsh-users/antigen.git ~/.antigen

echo "Vundle install..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "ssh install"
if [[ -f ~/.ssh ]]; then mv ~/.ssh ~/.ssh.orig; fi
cp -rf ~/.dotfiles/ssh-config ~/.ssh
chmod 0600 .ssh/*.id

