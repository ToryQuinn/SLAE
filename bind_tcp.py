#!/usr/bin/python

import socket
import sys
import os
import signal

HOST = ''
PORT = 4444
pid = os.getpid()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind(('',4444))

s.listen(10)
print "socket listening"
os.kill(pid, signal.SIGUSR1)
while 1:
    connection,address = s.accept()
    data = connection.recv(1024)
    print data
