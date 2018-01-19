#!/bin/bash

declare -a CONFBACKUP="~/.config/localdotbackup"

echo "[*] Backing up local dotfiles... "
# make backup directory
mkdir -p $CONFBACKUP

# global aliases
if [ -f ~/.aliases ]; then mv ~/.aliases "$CONFBACKUP/.aliases"; fi

# bash files
if [ -f ~/.bashrc ]; then mv ~/.bashrc "$CONFBACKUP/.bashrc"; fi
if [ -f ~/.dir_colors ]; then mv ~/.dir_colors "$CONFBACKUP/.dir_colors"; fi

# htop files
if [ -d ~/.config/htop ]; then mv ~/.config/htop/htoprc "$CONFBACKUP/htoprc"; mkdir -p ~/.config/htop; fi

# tmux files
if [ -d ~/.tmux ]; then mv ~/.tmux "$CONFBACKUP/.tmux"; fi

# vimrc files
if [ -d ~/.vim ]; then mv ~/.vim "$CONFBACKUP/.vim"; fi
if [ -f ~/.vimrc ]; then mv ~/.vimrc "$CONFBACKUP/.vimrc"; fi

# zsh file
if [ -f ~/.zshrc ]; then mv ~/.zshrc "$CONFBACKUP/.zshrc"; fi

# local files
if [ -d ~/.local/wallpaper ]; then mkdir -p "$CONFBACKUP/local"; mv ~/.local/wallpaper "$CONFBACKUP/local/wallpaper"; fi
if [ -d ~/.local/share/fonts ]; then mkdir -p "$CONFBACKUP/local/share/fonts"; mv ~/.local/share/fonts "$CONFBACKUP/local/share/fonts"; fi

# gitconfig file
if [ -f ~/.gitconfig ]; then mv ~/.gitconfig "$CONFBACKUP/.gitconfig"; fi

# i3 files
if [ -d ~/.config/i3 ]; then mv ~/.config/i3 "$CONFBACKUP/i3"; fi
if [ -d ~/.config/i3status ]; then mv ~/.config/i3status "$CONFBACKUP/i3status"; fi

# ranger files
if [ -d ~/.config/ranger ]; then mv ~/.config/ranger "$CONFBACKUP/ranger"; fi

# X files
if [ -f ~/.xinitrc ]; then mv ~/.xinitrc "$CONFBACKUP/.xinitrc"; fi
if [ -f ~/.Xresources ]; then mv ~/.Xresources "$CONFBACKUP/.Xresources"; fi

echo "[*] Installing new dotfiles... "

ln -s aliases ~/.aliases

ln -s bashrc ~/.bashrc
ln -s dir_colors ~/.dir_colors
ln -s config/htop/htoprc ~/.config/htop/htoprc
ln -s tmux.conf ~/.tmux.conf

ln -s vimrc ~/.vimrc
touch ~/.viminfo

ln -s zshrc ~/.zshrc

mkdir -p ~/.local/{wallpaper,share}
ln -s local/wallpaper/wallpaper.jpg ~/.local/wallpaper/wallpaper.jpg
ln -s local/share/fonts ~/.local/share/fonts

ln -s gitconfig ~/.gitconfig

ln -s config/i3 ~/.config/i3
ln -s config/i3status ~/.config/i3status

ln -s config/ranger ~/.config/ranger

ln -s xinitrc ~/.xinitrc
ln -s Xresources ~/.Xresources
