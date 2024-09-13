#!/bin/bash

cd docker-compose
docker compose -f $1 stop
docker compose -f $1 -p $1 up -d --remove-orphans
#docker compose -f $1 -p $1 up -d --pull=always --remove-orphans
cd ..
