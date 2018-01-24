#!/bin/bash
intern=eDP-1
lid_status=`cat /proc/acpi/button/lid/LID/state | awk '{print $2}'`
output_on=""
output_off=""
declare -a connected

connected=`DISPLAY=:0.0 su domazet -c "/usr/bin/xrandr --query" | egrep "\Wconnected\W" | grep -v "$intern" | awk '{print $1}'`
for port in ${connected[@]}; do
    output_on+=" --output \"$port\" --auto"
    output_off+=" --output \"$port\" --off"
done

if [ "$lid_status" == 'closed' ]; then
    DISPLAY=:0.0 su domazet -c "xrandr --output \"$intern\" --off $output_on"
    #logger "TM: LID: '$lid_status' | xrandr --output \"$intern\" --off ||| $output_on"
else
    DISPLAY=:0.0 su domazet -c "xrandr --output \"$intern\" --auto $output_off"
    #logger "TM: LID: '$lid_status' | xrandr --output \"$intern\" --auto ||| $output_off"
fi

# Disable DPMS and Screensaver blanking
DISPLAY=:0.0 su domazet -c "xset s off -dpms"

# Increase keypress rate
DISPLAY=:0.0 su domazet -c "xset r rate 200 30"

# German Keyboard
DISPLAY=:0.0 su domazet -c "setxkbmap -model thinkpad -layout de -variant nodeadkeys"
exit
