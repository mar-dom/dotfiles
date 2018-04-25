#!/bin/bash
# vim :set filetype=sh

# Check if localhost is reachable
if ! timeout 2 nc -z terminalsrv.aisec.fraunhofer.de 3389 ; then
    zenity --error --title "Error connecting to terminalsrv" --text "Could not connect to terminalsrv!"
    exit 1
fi

nohup xfreerdp  +sec-nla +clipboard +fonts \
                /kbd:0x00000407 /bpp:32 /rfx \
                /d:aisec /u:domazet /v:terminalsrv.aisec.fraunhofer.de \
                /drive:home,/home/domazet \
		/p:$(zenity --entry --title="Domain Password" --text="domazet@terminalsrv RDP Password:" --hide-text) \
                /app:"||ONENOTE" >/dev/null 2>&1 &
