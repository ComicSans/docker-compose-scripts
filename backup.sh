#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

docker stop homeassistant
docker stop mariadb

tar --exclude="backups" --exclude=".git" --exclude="configs/frigate/storage" -zcvf "backups/`date -I`.tar.gz" .

docker start mariadb
docker start homeassistant
