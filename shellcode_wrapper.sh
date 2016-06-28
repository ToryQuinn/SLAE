#!/bin/bash

SHELLCODE="$(objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
)"
echo $SHELLCODE

sed "s/{Shellcode_goes_here}/$SHELLCODE/" shellcode.c.template > shellcode.c

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
