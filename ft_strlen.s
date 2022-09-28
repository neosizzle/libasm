section .text

; rdi - the pointer to string in memory
; rax - the result to be returned
; cl - the current traversed character
global ft_strlen
ft_strlen:
	; stack frame init
	PUSH rdi ; push the input parameter to memory
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rcx ; push varaible initial state to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rax, -1; inital return value is zero
	CMP rdi, 0; check if rdi is 0
	JE null_case; if equal, jump to null_case
	JNE count_loop; if not, jump to loop

null_case : 
	; NULL case handle
	MOV rax, 0; ret value is zero
	call clean; skip to clean

count_loop:
	; char counter loop
	INC rax; increment result
	MOV cl, [rdi]; get character from string
	INC rdi; increment string pointer
	CMP cl, 0; check if char is zero
	JNE count_loop; if not zero, jump to loop start
clean:
	; stack frame cleanup
	POP rcx ; restore varaible initial state to register slot
	POP rbp; restore prev bottom stack to register slot
	POP rdi ; restore first parameter to register
	ret; return