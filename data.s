section .data
	MESSAGE DB "Hello, World", 10

section .text

; global _start

; _start:
; 	call hello;
global hello
hello:
	MOV R8, RDI; store message pointer
	MOV RAX, 1;sys_write
	MOV RDI, 1; stdout fd
	MOV RSI, R8; Message
	MOV RDX, 4; strlen
	syscall;syscall

	; MOV RAX, 60; sys_exit
	; MOV RDI, 0; status code 0
	ret; return