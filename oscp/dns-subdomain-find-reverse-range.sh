#!/bin/bash

for i in $(seq 1 254); do
	host 65.215.93.${i} | grep -v "not found" &
done
