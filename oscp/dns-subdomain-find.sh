#!/bin/bash

while read i; do
	host ${i}.subway.com | grep "has address" &
done < /opt/dns-wordlists/subdomains-10000.txt

