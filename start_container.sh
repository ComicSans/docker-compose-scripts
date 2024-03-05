#!/bin/bash
cd docker-compose
docker compose -f $1 -p $1 up -d  --pull=always
cd ..
