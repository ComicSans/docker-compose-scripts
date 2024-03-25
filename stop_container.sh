#!/bin/bash
docker stop -t 120 $(docker ps -a -q)
