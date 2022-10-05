section .text

; rdi - begin_list
; rax - counter & retvalue
global _ft_list_size
_ft_list_size:
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi ; save rdi to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rax, 0; init counter to 0

count_loop :
	CMP rdi, 0 ; check if begin list is null
	JE clean_ft_list_size ; jump to cleaup if it is
	INC rax ; increment counter
	ADD rdi, 8 ; increment rdi by 8 bytes to point to ->next
	MOV rdi, [rdi] ; begin_list = begin_list->next;
	JMP count_loop ; go to loop start


clean_ft_list_size:
	; stack frame cleanup
	POP rdi ; restore rdi
	POP rbp ; restore prev bottom stack to register slot
	ret; return