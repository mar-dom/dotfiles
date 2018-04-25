#!/bin/bash
# vim :set filetype=sh

connect=""

# Check if localhost is reachable
if timeout 2 nc -z localhost 13389 ; then
    connect="localhost:13389"
elif timeout 2 nc -z rds-ism.aisec.fraunhofer.de 3389 ; then
    connect="rds-ism.aisec.fraunhofer.de:3389"
fi

if [[ $connect == "" ]]; then
    zenity --error --title "Error connecting to RDS" --text "Could not connect to localhost or rds-ism!"
    exit 1
fi

nohup xfreerdp  +sec-nla +clipboard +fonts \
                /kbd:0x00000407 /bpp:32 /rfx \
                /u:adm-md /v:$connect \
                /size:1800x1150 \
                /drive:home,/home/domazet \
		/p:$(zenity --entry --title="Domain Password" --text="adm-md@rds-ism RDP Password:" --hide-text)  >/dev/null 2>&1 &

# else msg errir
