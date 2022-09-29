extern	__errno_location
extern	___error
SYS_READ_MAC equ 0x2000000
SYS_READ_LINUX equ 0
section .text

; rdi - the file descriptor to read
; rsi - the string to be read to
; rdx - the length of string to read
; rax - the result to be returned
; cl - the current traversed character
global ft_read
ft_read:
	; stack frame init
	PUSH rdi ; push the input parameter to memory
	PUSH rsi ; push the input parameter to memory
	PUSH rdx ; push the input parameter to memory
	PUSH r8 ; push the varaible to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rax, SYS_READ_LINUX; sys_write
	syscall ; execute syscall
	JC error; check if syscall failed when carry flag is set on mac
	CMP rax, 0; check if syscall failed when negative is returned on linux
	JLE error
	JAE clean

error:
	NEG rax; convert rax to positive
	MOV r8, rax; store err code in register r8
	CALL  __errno_location WRT ..plt; calls external errno function, will return 
	MOV [rax], r8; move error code in r8 to errno location return 
	MOV rax, -1; set ret value to negative

clean:
	; stack frame cleanup
	POP rbp; restore prev bottom stack to register slot
	POP r8 ; restore variable to register
	POP rdx; restore input param to register slot
	POP rsi; restore input param to register slot
	POP rdi ; restore first parameter to register
	ret; return