#!/bin/bash

echo "Start to build for docker..."

/usr/bin/python3 -m http.server 28294 &
docker build --network="host" -t rosetta .
kill -9 $(netstat -antp | grep :28294 | awk '{print $7}' | awk -F'/' '{ print $1 }')
