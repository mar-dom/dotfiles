[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

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

# Ensure dbus is either already running, or safely start it
if [[ -z "${DBUS_SESSION_BUS_ADDRESS}" ]]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    
    # Make the keyring daemon ready to communicate with nm-applet
    export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
    #export SSH_AUTH_SOCK
fi


exec i3
