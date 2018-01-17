[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Check if an external monitor is pluged in
intern=eDP-1
lid_status=`cat /proc/acpi/button/lid/LID/state | awk '{print $2}'`
output_on=""
output_off=""
declare -a connected

connected=`/usr/bin/xrandr --query | egrep "\Wconnected\W" | grep -v "$intern" | awk '{print $1}'`
for port in ${connected[@]}; do
    output_on+=" --output \"$port\" --auto"
    output_off+=" --output \"$port\" --off"
done

if [ "$lid_status" == 'closed' ]; then
    xrandr --output "$intern" --off $output_on
else
    xrandr --output "$intern" --auto $output_off
fi

# Disable DPMS and Screensaver blanking
xset s off -dpms

# Increase keypress rate
xset r rate 200 30

# German Keyboard
setxkbmap -model thinkpad -layout de -variant nodeadkeys

# Run Urxvt in daemon mode
( ( sleep 1 && /usr/bin/urxvtd -q -f -o ) & )

# keep X clipboard and cutbuffer in sync
autocutsel -s CLIPBOARD &
autocutsel -s PRIMARY &

# start dunst notifyd
dunst &

# Ensure dbus is either already running, or safely start it
if [[ -z "${DBUS_SESSION_BUS_ADDRESS}" ]]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

eval `ssh-agent`
export SSH_AUTH_SOCK

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
#exec i3

