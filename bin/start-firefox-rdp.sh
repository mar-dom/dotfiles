#!/bin/bash
# vim :set filetype=sh

nohup xfreerdp  +sec-nla +clipboard +fonts \
                /smartcard /printer /kbd:0x00000407 /bpp:32 /rfx \
                /u:adm-md /v:jump-ws.aisec.fraunhofer.de \
                /p:$(zenity --entry --title="Domain Password" --text="Enter your _password:" --hide-text) \
                /app:"||firefox" >/dev/null 2>&1 &
