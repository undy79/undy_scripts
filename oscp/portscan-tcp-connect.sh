#!/bin/bash

# checks to see if a port is open based on a tcp three-way handshake
# grep doesnt seem to be working right

for i in $(seq 1 254); do
	nc -nvv -w 1 -z 10.0.0.${i} 80,443 | grep open &
done	
