#!/bin/bash
# vim :set filetype=sh

nohup xfreerdp  +sec-nla +clipboard +fonts \
                /kbd:0x00000407 /bpp:32 /rfx \
                /u:adm-md /v:localhost:13389 \
                /size:1800x1150 \
		/p:$(zenity --entry --title="Domain Password" --text="Enter your _password:" --hide-text)  >/dev/null 2>&1 &
