#!/usr/bin/python

import socket
import sys

if len(sys.argv) !=3:
    print "Usage: script-name <username> <ip address>"
    sys.exit(0)

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Create a socket
connect=s.connect(( sys.argv[2] ,25))                # Connect to the server
banner=s.recv(1024)                                 # Receive the banner
s.send('VRFY ' + sys.argv[1] + '\r\n')               # send VRFY verb
result=s.recv(1024)                                # Get results
print result                                        # print results
s.close()                                           # close the connection    
