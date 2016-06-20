#!/usr/bin/python

import socket
import sys
import os

HOST = ''
PORT = 4444

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind(('',4444))

s.listen(10)
print "socket listening"

while 1:
    connection,address = s.accept()
    data = connection.recv(1024)
    print data
