#!/bin/bash

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
if [ -d ~/.config/htop ]; then
        mv ~/.config/htop/htoprc ~/.config/localdotbackup/htoprc
        mkdir -p ~/.config/htop
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
touch ~/.viminfo

# zsh files
if [ -f ~/.zshrc ]; then
        mv ~/.zshrc ~/.config/localdotbackup/.zshrc
fi
ln -s ~/.dotfiles/zshrc ~/.zshrc

# local files
if [ -d ~/.local/wallpaper ]; then
        mkdir -p /.config/localdotbackup/local
        mv ~/.local/wallpaper ~/.config/localdotbackup/local/wallpaper
fi
mkdir -p ~/.local/wallpaper/
ln -s ~/.dotfiles/local/wallpaper/wallpaper.jpg ~/.local/wallpaper/wallpaper.jpg

if [ -d ~/.local/share/fonts ]; then
        mkdir -p /.config/localdotbackup/local/share/fonts
        mv ~/.local/share/fonts ~/.config/localdotbackup/local/share/fonts
fi
mkdir -p ~/.local/share
ln -s ~/.dotfiles/local/share/fonts ~/.local/share/fonts

# i3
if [ -d ~/.config/i3 ]; then
        mv ~/.config/i3 ~/.config/localdotbackup/i3
fi
ln -s ~/.dotfiles/config/i3 ~/.config/i3

# i3status
if [ -d ~/.config/i3status ]; then
        mv ~/.config/i3status ~/.config/localdotbackup/i3status
fi
ln -s ~/.dotfiles/config/i3status ~/.config/i3status

# ranger
if [ -d ~/.config/ranger ]; then
        mv ~/.config/ranger ~/.config/localdotbackup/ranger
fi
ln -s ~/.dotfiles/config/ranger ~/.config/ranger

# X Resources
if [ -f ~/.xinitrc ]; then
        mv ~/.xinitrc ~/.config/localdotbackup/.xinitrc
fi
ln -s ~/.dotfiles/xinitrc ~/.xinitrc

if [ -f ~/.Xresources ]; then
        mv ~/.Xresources ~/.config/localdotbackup/.Xresources
fi
ln -s ~/.dotfiles/Xresources ~/.Xresources

