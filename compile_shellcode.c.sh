#!/bin/bash

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
