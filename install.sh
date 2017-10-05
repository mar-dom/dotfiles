#!/bin/bash

# install dependencies
sudo apt-get install -y -qq htop wget curl git zsh tmux vim-nox fortune > /dev/null

if [ ! $? -eq 0 ]; then
    echo "Error: could not install dependencies!"
    exit -1
fi

# make backup directory
mkdir -p .config/localdotbackup

# copy gitconfig
if [ -f ~/.gitconfig ]; then
	mv ~/.gitconfig ~/.config/localdotbackup/.gitconfig
fi
cp ~/.dotfiles/gitconfig ~/.gitconfig

# global aliases
if [ -f ~/.aliases ]; then
	mv ~/.aliases ~/.config/localdotbackup/.aliases
fi
ln -s ~/.dotfiles/aliases ~/.aliases

# bash files
if [ -f ~/.bashrc ]; then
        mv ~/.bashrc ~/.config/localdotbackup/.bashrc
fi
if [ -f ~/.dir_colors ]; then
	mv ~/.dir_colors ~/.config/localdotbackup/.dir_colors
fi
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/dir_colors ~/.dir_colors

# htop config
mkdir -p ~/.config/htop
if [ -f ~/.config/htop/htoprc ]; then
        mv ~/.config/htop/htoprc ~/.config/localdotbackup/htoprc
fi
ln -s ~/.dotfiles/config/htop/htoprc ~/.config/htop/htoprc

# tmux files
if [ -d ~/.tmux ]; then
        mv ~/.tmux ~/.config/localdotbackup/.tmux
fi
if [ -f ~/.vimrc ]; then
        mv ~/.tmux.conf ~/.config/localdotbackup/.tmux.conf
fi
ln -s ~/.dotfiles/tmux ~/.tmux 
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

# vim files
if [ -d ~/.vim ]; then
        mv ~/.vim ~/.config/localdotbackup/.vim
fi
if [ -f ~/.vimrc ]; then
        mv ~/.vimrc ~/.config/localdotbackup/.vimrc
fi
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vimrc ~/.vimrc

# zsh files
if [ -f ~/.zshrc ]; then
        mv ~/.zshrc ~/.config/localdotbackup/.zshrc
fi
ln -s ~/.dotfiles/zshrc ~/.zshrc

