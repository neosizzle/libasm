section .text

; rdi - begin_list
; rsi - compare func
; r10 - current node
; rdx - temp variable to store data
; rbx - next node after curr
; r12 - begin_list copy
; r9 - cmp func copy
global _ft_list_sort
_ft_list_sort:
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi ; save rdi to memory
	PUSH rsi ; save rsi to memory
	PUSH r10 ; save r10 to memory
	PUSH rdx ; save rdx to memory
	PUSH rbx ; save rbx to memory
	PUSH r12 ; save r12 to memory
	PUSH r9 ; save r9 to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	CMP rdi, 0; check if begin list is 0;
	JE clean_ft_list_sort; if yes, skip to clean
	CMP word [rdi], 0; check if val of begin list is 0;
	JE clean_ft_list_sort; if yes, skip to clean

	MOV r10, [rdi] ; curr = *begin_list

	MOV r12, rdi; begin list copy
	MOV r9, rsi; cmp func copy

iter_loop:
	CMP word [r10 + 8], 0 ; curr->next === 0
	JE clean_ft_list_sort ; jump to clean
	MOV rbx, [r10 + 8] ; load next node to rbx
	MOV rdi, [r10] ; move curr->data to first arg
	MOV rsi, [rbx] ; move next->data to 2nd arg
	CALL r9 ; call r9
	; CMP rax, 0; campare ret value with zero
	; TEST rax, rax
	JLE increm_loop ; jump to increm lop if ret <= 0
	JG move_data_loop ; jump to move_data_loop if res > 0

move_data_loop :
	MOV rsi, [rbx] ; load next data into rsi
	MOV rdx, [r10] ; temp = curr->data
	MOV [r10], rsi ; curr->data = next->data
	MOV [rbx], rdx ; curr->next->data = temp
	MOV r10, [r12] ; curr = *begin_list
	JMP iter_loop_end; jump to loop end
	JMP increm_loop ;

increm_loop :
	ADD r10, 8; increm r10 by 8 so get -> next
	MOV r10, [r10] ; curr = curr->next
	JMP iter_loop_end; jump to loop end

iter_loop_end:
	JMP iter_loop; jump to loop start

clean_ft_list_sort:
	; stack frame cleanup
	POP r9 ; restore r9
	POP r12 ; restore r12
	POP rbx ; restore rbx
	POP rdx ; restore rdx
	POP r10 ; restore r10
	POP rsi ; restore rsi
	POP rdi ; restore rdi
	POP rbp ; restore prev bottom stack to register slot
	ret; return