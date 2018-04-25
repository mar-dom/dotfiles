#!/bin/bash

$(tmux has-session -t "local" 2>/dev/null)

if [ $? -eq 0 ]; then

    tmux new-window -k -t "local:2" -n "tunnel to jump-ws" \
    'ssh-add ~/.ssh/ssh-jump-ws.id; \
     autossh -M 0 -T -N -4 -p 22 \
     -L13389:rds-ism.aisec.fraunhofer.de:3389 \
     -l adm-md \
     -i "~/.ssh/ssh-jump-ws.id" \
     -o "ExitOnForwardFailure yes" -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" \
     jump-ws.aisec.fraunhofer.de;'

    tmux -2 attach-session -t "local"
fi


