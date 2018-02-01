#!/bin/bash

$(tmux has-session -t "local syslog" 2>/dev/null)

if [ $? -eq 1 ]; then
    # session local syslog | syslog window
    tmux -2 new-session -d -s "local syslog" -n "syslog" 'lnav /var/log/auth.log' # pane 0
    tmux split-window -v 'lnav /var/log/network.log' # pane 2
    tmux split-window -h 'lnav /var/log/syslog' # pane 3
    tmux selectp -t 0
    tmux split-window -h 'lnav /var/log/kernel.log' #pane 1
    
    # switch to syslog window
    tmux select-window -t "syslog"
    tmux selectp -t 0
fi
    
tmux -2 attach-session -t "local syslog"
