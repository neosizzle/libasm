section .text

; rdi - the pointer to list head
; rsi - new data to be added
global ft_list_push_front
ft_list_push_front:
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi ;
	PUSH rsi ;
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rdx, [rdi];
	MOV rcx, [rdx];
	MOV rcx, [rdx + 4];
	MOV rcx, [rdx + 8];


clean_ft_list_push_front:
	; stack frame cleanup
	POP rsi;
	POP rdi;
	POP rbp; restore prev bottom stack to register slot
	ret; return