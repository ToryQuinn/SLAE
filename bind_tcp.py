#!/usr/bin/python

import socket
import os




s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind(('',4444))

s.listen(10)

while 1:
    connection,address = s.accept()
    data = connection.recv(1024)
    os.execve('/bin/ls',None,None)
