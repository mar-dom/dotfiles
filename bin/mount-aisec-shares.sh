#!/bin/bash

/home/domazet/.dotfiles/bin/umount-aisec-shares.sh

sudo mkdir -p /media/aisec/{AISEC,ISM,home,ISB}
sudo chown -R domazet.domazet /media/aisec/

USERNAME="domazet"
PASSWORD=$(zenity --entry --title="Domain Password" --text="domazet@FILESERVER:" --hide-text)
DOMAIN="AISEC"

#echo -n "Domain Password for domazet: " 
#read -s PASSWORD
#echo 

sudo mount -t cifs -o vers=3.0,username=$USERNAME,domain=$DOMAIN,password=$PASSWORD,uid=1000,gid=1000 //fileserver.aisec.fraunhofer.de/AISEC /media/aisec/AISEC
sudo mount -t cifs -o vers=3.0,username=$USERNAME,domain=$DOMAIN,password=$PASSWORD,uid=1000,gid=1000 //fileserver.aisec.fraunhofer.de/ISM /media/aisec/ISM
sudo mount -t cifs -o vers=3.0,username=$USERNAME,domain=$DOMAIN,password=$PASSWORD,uid=1000,gid=1000 //fileserver.aisec.fraunhofer.de/home/domazet /media/aisec/home
sudo mount -t cifs -o vers=3.0,username=$USERNAME,domain=$DOMAIN,password=$PASSWORD,uid=1000,gid=1000 //fileserver.aisec.fraunhofer.de/ISB /media/aisec/ISB

