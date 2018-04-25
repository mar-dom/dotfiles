#!/bin/bash

$(tmux has-session -t "local" 2>/dev/null)

if [ $? -eq 1 ]; then
    # session local syslog | syslog window
    tmux -2 new-session -d -s "local" -n "syslog" 'lnav /var/log/auth.log' # pane 0
    tmux split-window -v 'lnav /var/log/network.log' # pane 2
    tmux split-window -h 'lnav /var/log/syslog' # pane 3
    tmux selectp -t 0
    tmux split-window -h 'lnav /var/log/kernel.log' #pane 1
fi
