section .text

; rdi - the pointer to destination string in memory
; rsi - the pointer to source string in memory
; rax - the result to be returned
; cl - the current traversed character in source
global ft_strcpy
ft_strcpy:
	; stack frame init
	PUSH rdi ; push the dest parameter to memory
	PUSH rsi ; push the src parameter to memory
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rcx ; push varaible initial state to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)
	MOV rax, rdi; inital return value is dest str

	CMP rdi, 0; check if rdi is 0
	JE null_case; if equal, jump to null_case
	CMP rsi, 0; check if rsi is 0
	JE null_case; if eq, just to null case
	JNE append_loop; if not, jump to append character loop

null_case : 
	; NULL case handle
	MOV rax, 0; ret value is zero
	call clean; skip to clean

append_loop:
	; char counter loop
	MOV cl, [rsi]; get character from source string
	MOV [rdi], cl; move character into dest 
	INC rsi; increment source string pointer
	INC rdi; increment dest string pointer
	CMP cl, 0; check if char is zero
	JNE append_loop; if not zero, jump to loop start
clean:
	; stack frame cleanup
	POP rcx ; restore varaible initial state to register slot
	POP rbp; restore prev bottom stack to register slot
	POP rsi ; restore 2nd parameter to register
	POP rdi ; restore first parameter to register
	ret; return