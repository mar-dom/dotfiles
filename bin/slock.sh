#!/bin/bash

scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -blur "0x15" /tmp/screen_locked.png
#convert /tmp/screen_locked.png -charcoal 5 /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png -t  && sleep 1
rm -f /tmp/screen_locked.png
