#!/bin/bash
# vim :set filetype=sh

nohup xfreerdp  +sec-nla +clipboard +fonts \
                /kbd:0x00000407 /bpp:32 /rfx \
                /d:aisec /u:domazet /v:terminalsrv.aisec.fraunhofer.de \
		/p:$(zenity --entry --title="Domain Password" --text="Enter your _password:" --hide-text) \
                /app:"||WINWORD" >/dev/null 2>&1 &
