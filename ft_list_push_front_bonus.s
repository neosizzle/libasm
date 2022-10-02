extern malloc

section .text
STRUCT_SIZE:  equ  16

; rdi - begin_list
; rsi - data
; r10 - begin_list copy
; r9 - data copy
; rbx - new struct
; rdx - loaded begin_list
global ft_list_push_front
ft_list_push_front:
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi ; save rdi to memory
	PUSH rsi ; save rsi to memory
	PUSH r10 ; save r10 to memory
	PUSH rbx ; save rbx to memory
	PUSH r9 ; save r9 to memory
	PUSH rdx ; save rdx to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	CMP rdi, 0 ; (begin_list == NULL)
	JE clean_ft_list_push_front ; jump to error return

	MOV r10, rdi ;begin_list copy
	MOV r9, rsi ; data copy

	MOV rdi, STRUCT_SIZE ; set up param for malloc
	CALL malloc  WRT ..plt;  malloc(sizeof(t_list))
	CMP rax, 0; (mallocRet == NULL)
	JE clean_ft_list_push_front ; jump to error return

	MOV rdx, [r10]; load rdx with deref r10
	MOV rbx, rax; move new struct ptr to rbx
	MOV [rbx], r9 ; new->data = data;
	MOV [rbx + 8], rdx ; new->next = *begin_list;
	MOV [r10], rbx  ; *begin_list = new;

clean_ft_list_push_front:
	; stack frame cleanup
	POP rdx ; restore rdx
	POP r9 ; restore r9
	POP rbx ; restore rbx
	POP r10 ; restore r10 
	POP rsi ; restore rsi
	POP rdi ; restore rdi
	POP rbp ; restore prev bottom stack to register slot
	ret; return