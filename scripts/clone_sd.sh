#!/bin/bash

lsblk
echo
read -t 30 -p "Check for sda and press ctrl-c to stop..."


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo rpi-clone sda
