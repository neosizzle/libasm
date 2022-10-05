extern _free

section .text

global _ft_list_remove_if

; helper func to free curr node and curr node data
; rdi - free function
; rbx - curr node copy
; rdx - free function copy
_free_curr : 
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi
	PUSH rsi
	PUSH rdx
	PUSH rcx
	PUSH rbx
	PUSH r9
	PUSH r10
	PUSH r11
	PUSH r12
	PUSH r13
	PUSH r14
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rdx, rdi ; copy func ptr
	MOV rbx, r11 ; copy curr node
	MOV rdi, [r11] ; take g_curr->data and put it as first arg
	CALL rdx ; free_fct(g_curr->data);
	MOV rdi, rbx ; move curr node ptr to first arg of free
	CALL _free; call free 


	; stack frame cleanup
	POP r14
	POP r13
	POP r12
	POP r11
	POP r10
	POP r9
	POP rbx
	POP rcx
	POP rdx
	POP rsi
	POP rdi
	POP rbp ; restore prev bottom stack to register slot
	ret; return

; healer function to move curr node forards and set prev node
move_fwd : 
	MOV r10, r11;g_prev = g_curr;
	MOV r11, [r11 + 8];g_curr = g_curr->next;
	ret; return

; rdi - begin_list
; rsi - data
; rdx - cmp function
; rcx -  free function

; rbx - data copy
; r9 - begin_list copy
; r10 - previous node ptr
; r11 - curr node ptr
; r12 - temp node ptr
; r13 - free funct copy
; r14 - cmp funct copy 
_ft_list_remove_if:
	; stack frame init
	PUSH rbp ; push the current bottom of stack to memory
	PUSH rdi
	PUSH rsi
	PUSH rdx
	PUSH rcx
	PUSH rbx
	PUSH r9
	PUSH r10
	PUSH r11
	PUSH r12
	PUSH r13
	PUSH r14
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV r11, [rdi]; g_curr = *begin_list
	MOV r9, rdi; begin_list copy
	MOV rbx, rsi; data copy
	MOV r13, rcx; free func copy
	MOV r14, rdx; cmp function copy

init_remove_loop :
	CMP r11, 0 ; g_curr == 0?
	JZ curr_null_check ; jump to curr null check
	MOV rdi, [r11] ; move g_curr->data into first arg
	MOV rsi, rbx; move data ref into 2nd arg
	CALL r14; call compare function
	JNZ curr_null_check ; jump to curr null check if res not zero

	MOV r12, [r11 + 8]; temp = g->curr->next
	MOV [r9], r12; *begin_list = temp;
	MOV rdi, r13 ; move free_func as first arg
	CALL _free_curr ; free_curr(free_fct)
	MOV r11, [r9]; g_curr = *begin_list;
	JMP init_remove_loop ; jump to init remove loop start

curr_null_check :
	CMP r11, 0 ; g_curr === 0?
	JZ clean_ft_list_remove_if ; return
	CMP word [r11 + 8], 0; g_curr->next === 0?
	JZ clean_ft_list_remove_if ; return

	CALL move_fwd ; move_forward();

main_remove_loop :
	CMP r11, 0 ; g_curr === 0?
	JZ clean_ft_list_remove_if ; return
	MOV rdi, [r11] ; move g_curr->data into first arg
	MOV rsi, rbx; move data ref into 2nd arg
	CALL r14; call compare function
	JNZ main_remove_loop_end ; != 0, jump to loopend
	MOV r12, [r11 + 8] ; temp = g_curr->next;
	MOV rdi, r13 ; move free_func as first arg
	CALL _free_curr ; free_curr(free_fct)
	MOV [r10 + 8], r12; g_prev->next = temp
	MOV r11, r12; g_curr = temp
	JMP main_remove_loop; go to loop start

main_remove_loop_end :
	CALL move_fwd; move_forward()
	JMP main_remove_loop

clean_ft_list_remove_if:
	; stack frame cleanup
	POP r14
	POP r13
	POP r12
	POP r11
	POP r10
	POP r9
	POP rbx
	POP rcx
	POP rdx
	POP rsi
	POP rdi
	POP rbp ; restore prev bottom stack to register slot
	ret; return