#!/bin/bash

while read i; do
	host ${i}.subway.com | grep "has address" | cut -d " " -f 4 >> /tmp/reverse.txt &	
done < /opt/dns-wordlists/subdomains-10000.txt

cat /tmp/reverse.txt | uniq > /tmp/reverse2.txt

while read j; do
	dig -x ${j} | grep subway.com | grep PTR
done < /tmp/reverse2.txt

