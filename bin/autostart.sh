#!/bin/bash

# keepass
nohup keepass > /dev/null 2>&1 &

# firefox
nohup firefox-bin > /dev/null 2>&1 &

# thunderbird
nohup thunderbird-bin > /dev/null 2>&1 & 

# pidgin
nohup pidgin > /dev/null 2>&1 & 

# ssh keys + autossh
nohup st -e sh -c "ssh-add ~/.ssh/aisec/*.id; ~/.dotfiles/bin/tmux_autossh.sh" > /dev/null 2>&1 &
