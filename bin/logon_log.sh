#!/bin/bash
tmux new-session -d -s "muc-nb-039" -n "syslog" lnav /var/log/auth.log
tmux split-window -v lnav /var/log/network.log
tmux split-window -h lnav /var/log/syslog
tmux selectp -t 0
tmux split-window -h lnav /var/log/kernel.log
tmux selectp -t 0
tmux attach -t "muc-nb-039"

