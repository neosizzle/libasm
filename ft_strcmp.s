section .text

; rdi - the pointer s1 to compare
; rsi - the pointer s2 to compare
; rax - the result to be returned
; cl - the current traversed character in s1
; dl - the current traversed character in s2
global ft_strcmp 
ft_strcmp:
	; stack frame init
	PUSH rdi ; push s1 init state to memory
	PUSH rsi ; push s2 init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rcx ; push s1 char init state to memory
	PUSH rdx ; push s2 char init state to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)
	MOV rax, rdi; inital return value is dest str

	CMP rdi, 0; check if s1 is 0
	JE null_case; if equal, jump to null_case
	CMP rsi, 0; check if s2 is 0
	JE null_case; if eq, just to null case
	JNE append_loop; if not, jump to append character loop

null_case : 
	; NULL case handle
	MOV rax, 0; ret value is zero
	call clean; skip to clean

append_loop:
	; char counter loop
	XOR rcx, rcx; clear rcx
	XOR rdx,rdx; clear rdx
	MOV cl, [rdi]; get character from s1
	MOV dl, [rsi]; get character from s2

	MOV rax, rcx; Move character to return value
	SUB rax, rdx; store the subtract result in ret 
	CMP rax, 0; if subtract is not equal zero
	JNE clean; jump to clean

	INC rsi; increment s1 string pointer
	INC rdi; increment s2 string pointer
	CMP cl, 0; check if s1 char is zero
	JNE append_loop; if not zero, jump to loop start
clean:
	; stack frame cleanup
	POP rdx ; restore s2 initial state to register slot
	POP rcx ; restore s1 initial state to register slot
	POP rbp; restore prev bottom stack to register slot
	POP rsi ; restore 2nd parameter to register
	POP rdi ; restore first parameter to register
	ret; return