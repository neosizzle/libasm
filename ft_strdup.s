extern _ft_strlen
extern _ft_strcpy
extern _malloc

section .text
; rdi - the pointer to string in memory
; rax - the result to be returned
; r14 - clone of rdi
; cl - the current traversed character
global _ft_strdup
_ft_strdup:
	; stack frame init
	PUSH rdi ; push the input parameter to memory
	PUSH r14; push r14 init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	CMP rdi, 0; check if rdi is 0
	JE null_case; if equal, jump to null_case
	JNE alloc; if not, jump to alloc

null_case : 
	; NULL case handle
	MOV rax, 0; ret value is zero
	CALL clean_strdup; skip to clean

alloc :
	CALL _ft_strlen; get strlen in in rax;
	ADD rax, 1; strlen + 1 to count null term
	MOV r14, rdi; clone string to r14
	; PUSH rdi ; put string in memory
	MOV rdi, rax; move strlen to first arg (rdi)
	CALL _malloc ; WRT .plt It's a notation for the way the platform you are learning uses to link to symbols defined in external modules.
	CMP rax, 0; compare malloc return to null
	JE null_case; jump to null case if malloc fails


copy : 
	MOV rdi, rax; move malloc returned address to destination for strcpy 
	MOV rsi, r14; move src string to 2nd arg strcpy
	; POP rsi ; move prev rdi in memory into curr rsi
	CALL _ft_strcpy; call ft_strcpy

clean_strdup:
	; stack frame cleanup
	POP rbp; restore prev bottom stack to register slot
	POP r14 ; restore r14 
	POP rdi ; restore first parameter to register
	ret; return