#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

docker stop $(docker ps -a -q) 

tar --exclude="backups" --exclude=".git" -zcvf "backups/`date -I`.tar.gz" .

docker start $(docker ps -a -q)
