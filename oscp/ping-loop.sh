#!/bin/bash

for i in $(seq 1 254); do 
ping -c 2 10.0.0.${i} -W 200 | grep "bytes from"  | cut -d " " -f 4 | uniq & 
done
