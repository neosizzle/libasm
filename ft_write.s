extern	___error
SYS_WRITE_MAC equ 0x2000004
SYS_WRITE_LINUX equ 1
section .text

; rdi - the file descriptor to write to
; rsi - the string to be writted
; rdx - the length of string to write
; rax - the result to be returned
; cl - the current traversed character
global _ft_write
_ft_write:
	; stack frame init
	PUSH rdi ; push the input parameter to memory
	PUSH rsi ; push the input parameter to memory
	PUSH rdx ; push the input parameter to memory
	PUSH r8 ; push the varaible to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	CMP rdx, 0; see if length of string is zero
	JE length_zero; if yes, jump to length zero

	MOV rax, SYS_WRITE_MAC; sys_write
	syscall ; execute syscall
	JC error; check if syscall failed when carry flag is set on mac
	; CMP rax, 0; check if syscall failed when negative is returned on linux
	; JLE error
	JMP clean

error:
	MOV r8, rax; save current value from write to r8 (actual errno)
	call ___error ; call errno to get pointer to errno loation
	MOV [rax], r8 ; move errno to pointer
	MOV rax, -1 ; return -1
	JMP clean; jump to clean

length_zero:
	MOV rax, 0; move 0 to retvalue
	JMP clean;jump to clean

clean:
	; stack frame cleanup
	POP rbp; restore prev bottom stack to register slot
	POP r8 ; restore variable to register
	POP rdx; restore input param to register slot
	POP rsi; restore input param to register slot
	POP rdi ; restore first parameter to register
	ret; return