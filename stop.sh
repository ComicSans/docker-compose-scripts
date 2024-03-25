#!/bin/bash

cd docker-compose
docker compose -f $1 stop
cd ..
