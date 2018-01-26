#!/bin/bash

if [ -z "$1" ]
then
	echo "Usage: $0 <domain name>"
else	
for i in $(host -t ns $1 | cut -d " " -f 4); do
	host -l $1 $i
done
fi

