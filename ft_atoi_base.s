extern ft_strlen

section .text

global ft_atoi_base 

; helper function to check if base valid
; rdi - base to check
; rcx - i counter pointer
; rdx - j counter pointer
; rbx - base string clone
is_valid_base :
	; stack init
	PUSH rdi ; push string init state to memory
	PUSH rbx ; push rbx init state to memory
	PUSH rcx ; push rcx init state to memory
	PUSH rdx ;push rdx init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rbx, rdi; clone rdi to rbx
	CALL ft_strlen; call ft_strlen(base str);
	CMP rax, 2; compare result with 0
	JB is_valid_base_invalid_base; if less than two, jump to invalid base
	MOV rcx, rbx; set rcx to point to base


is_valid_base_i_loop :
	MOV rdx, rcx; set value of rdx equals rcx
	ADD rdx, 1; increment value of rdx + 1

is_valid_base_j_loop  :
	CMP [rdx], [rcx]; check if value of rdx is equal to value if rcx
	JE is_valid_base_invalid_base; if they are equal, jump to invalid base
	CMP [rdx], 32; check if value of rdx is lte 32 (not printable)
	JLE is_valid_base_invalid_base; if true, jump to invalid base
	CMP [rdx], 43; check if value of rdx is (+)
	JE is_valid_base_invalid_base; if true, jump to invalid base
	CMP [rdx], 45; check if value of rdx is (-)
	JE is_valid_base_invalid_base; if true, jump to invalid base
	INC rdx; increment rdx
	CMP [rdx], 0 ; check if value of rdx is null char
	JNE is_valid_base_j_loop; if not equal, jump back to loop start j

is_valid_base_i_loop_end :
	INC rcx; increment rcx
	CMP [rcx], 0 ; check if value of rdx is null char
	JNE is_valid_base_i_loop; if not equal, jump back to loop start i
	MOV rax, 1; set ret val to one
	JMP clean_is_valid_base; skip to cleam

is_valid_base_invalid_base :
	MOV rax, 0; set return value to 0


clean_is_valid_base :
	; stack clean
	POP rbp; restore prev bottom stack to register slot
	POP rdx; restore rdx
	POP rcx; restore rcx
	POP rbx; restore rbx
	POP rdi ; restore first parameter to register
	ret; return

; helper function to determine if char given is found in str. 
; If found, return pointer to char
; if not found. return 0

; rdi - the string to check
; rsi - the character to look for
char_in_base:
	; stack init
	PUSH rdi ; push string init state to memory
	PUSH rsi ; push char init state ro memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

char_in_base_loop:
	CMP [rdi], rsi;compare current value of str to char
	JE char_in_base_found;jump to char in base found if they are equal
	INC rdi; increment rdi
	CMP [rdi], 0; compare current character to nullbyte
	JNE char_in_base_loop; jump to char in base loop if not equals

char_in_base_found:
	MOV rax, rdi; move current str pointer to return value

clean_char_in_base:
	; stack clean
	POP rbp ; restore prev bottom stack to register slot
	POP rsi ; restore rsi
	POP rdi ; restore first parameter to register
	ret; return

; rdi - string to convert
; rsi - conversion base string
; r8 - clone of rdi (str)
; r9 - clone of rsi (base)
; r10 - soon to be return value
ft_atoi_base:
	; stack frame init
	PUSH rdi ; push string init state to memory
	PUSH rsi ; push base init state to memory
	PUSH r8 ; push r8 init state to memory
	PUSH r9 ;push r9 init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)
	
	MOV r8, rdi; move rdi to r8
	MOV r9, rsi; move rsi to r9

	MOV rdi, rsi; move base to rdi for valid base call
	CALL is_valid_base; call is valid base
	CMP rax, 0; check if the ret of valid base is zero
	JE clean_atoi_base; jump to clean if it is (invalid base)

	MOV r10, 0; init return value


skip_whitespace_loop:

polarity_loop:

result_generation_loop:

clean_atoi_base:
; stack frame cleanup
	POP rbp; restore prev bottom stack to register slot
	POP r9; restore r9
	POP r8; restore r8
	POP rsi; restore  2nd parameter to register
	POP rdi ; restore first parameter to register
	ret; return
