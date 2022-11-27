#!/bin/bash

echo "Start to build for singularity..."

/usr/bin/python3 -m http.server 28293 &
singularity build --fakeroot rosetta.sif Singularity.def
kill -9 $(netstat -antp | grep :28293 | awk '{print $7}' | awk -F'/' '{ print $1 }')
