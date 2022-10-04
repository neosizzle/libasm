extern ft_strlen

section .text

global ft_atoi_base 

; helper function to check if base valid
; rdi - base to check
; rcx - i counter pointer
; rdx - j counter pointer
; rbx - base string clone
; r8 - current char to compare against
is_valid_base :
	; stack init
	PUSH rdi ; push string init state to memory
	PUSH rbx ; push rbx init state to memory
	PUSH rcx ; push rcx init state to memory
	PUSH rdx ; push rdx init state to memory
	PUSH r8 ; push r8 init state to memory
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
	CMP byte [rdx], 0 ; check if value of rdx is null char
	JE is_valid_base_i_loop_end; if equal, jump i_loop end

is_valid_base_j_loop  :
	MOV r8b, [rcx]; load rcx char to r8; 
	CMP byte [rdx], r8b; check if value of rdx is equal to value if rcx
	JE is_valid_base_invalid_base; if they are equal, jump to invalid base
	CMP byte [rdx], 32; check if value of rdx is lte 32 (not printable)
	JLE is_valid_base_invalid_base; if true, jump to invalid base
	CMP byte [rdx], 43; check if value of rdx is (+)
	JE is_valid_base_invalid_base; if true, jump to invalid base
	CMP byte [rdx], 45; check if value of rdx is (-)
	JE is_valid_base_invalid_base; if true, jump to invalid base
	INC rdx; increment rdx
	CMP byte [rdx], 0 ; check if value of rdx is null char
	JNE is_valid_base_j_loop; if not equal, jump back to loop start j

is_valid_base_i_loop_end :
	INC rcx; increment rcx
	CMP byte [rcx], 0 ; check if value of rdx is null char
	JNE is_valid_base_i_loop; if not equal, jump back to loop start i
	MOV rax, 1; set ret val to one
	JMP clean_is_valid_base; skip to cleam

is_valid_base_invalid_base :
	MOV rax, 0; set return value to 0


clean_is_valid_base :
	; stack clean
	POP rbp; restore prev bottom stack to register slot
	POP r8 ; restore r8
	POP rdx; restore rdx
	POP rcx; restore rcx
	POP rbx; restore rbx
	POP rdi ; restore first parameter to register
	ret; return

; helper function to determine if char given is found in str. 
; If found, return pointer to char
; if not found. return 0

; rdi - the string to check
; rsi - the character pointer to look for
; rcx - the char value rsi is pointing to 
char_in_base:
	; stack init
	PUSH rdi ; push string init state to memory
	PUSH rsi ; push char init state ro memory
	PUSH rcx ; push char init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	MOV rax, 0; init ret value is zero
	CMP byte [rsi], 0; check if character that was pointed to is null
	JE clean_char_in_base; if yes, skip to clean

char_in_base_loop:
	MOV cl, [rsi]; move character into rcx
	CMP byte [rdi], cl;compare current value of str to char
	JE char_in_base_found;jump to char in base found if they are equal
	INC rdi; increment rdi
	CMP byte [rdi], 0; compare current character to nullbyte
	JNE char_in_base_loop; jump to char in base loop if not equals
	JE clean_char_in_base; if its end of string, the char isnt found

char_in_base_found:
	MOV rax, rdi; move current str pointer to return value

clean_char_in_base:
	; stack clean
	POP rbp ; restore prev bottom stack to register slot
	POP rcx ; restore rcx
	POP rsi ; restore rsi
	POP rdi ; restore first parameter to register
	ret; return

; rdi - string to convert
; rsi - conversion base string
; r8 - clone of rdi (str)
; r9 - clone of rsi (base)
; r10 - soon to be return value
; r11 - polarity
ft_atoi_base:
	; stack frame init
	PUSH rdi ; push string init state to memory
	PUSH rsi ; push base init state to memory
	PUSH r8 ; push r8 init state to memory
	PUSH r9 ;push r9 init state to memory
	PUSH r10 ;push r10 init state to memory
	PUSH r11 ;push r11 init state to memory
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)
	
	MOV r8, rdi; move rdi to r8
	MOV r9, rsi; move rsi to r9
	MOV r10, 0; init return value
	MOV r11, 1; polarity

	MOV rdi, rsi; move base to rdi for valid base call
	CALL is_valid_base; call is valid base
	CMP rax, 0; check if the ret of valid base is zero
	JE clean_atoi_base; jump to clean if it is (invalid base)


skip_whitespace_loop:
	CMP byte [r8], 32; check if val of curr pointer is space
	JNE polarity_loop; if not, skip
	INC r8; if yes, increment r8
	JMP skip_whitespace_loop; jump to loop start

flip_polarity:
	NEG r11
	ret;

select_polarity:
	; stack init
	PUSH rdx ; push res of *curr_ptr == '+'
	PUSH rbx ; push res of *curr_ptr == '-'
	PUSH rbp ; push the current bottom of stack to memory
	MOV rbp, rsp ; move the bottom stack pointer to curr top stack (create new stack)

	XOR rbx, rbx; clear rbx
	XOR rdx, rdx; clear rdx

select_polarity_plus:
	CMP byte [r8], 43; *curr_ptr == '+'
	JNE select_polarity_minus; compare minus
	MOV rdx , 1

select_polarity_minus:
	CMP byte [r8], 45; *curr_ptr == '-'
	JNE clean_select_polarity; jmp to clean
	MOV rbx , 1

clean_select_polarity:
	; stack clean
	OR rdx, rbx; get the or for both results
	MOV rax, rdx; move result to retvalue

	POP rbp ; restore prev bottom stack to register slot
	POP rbx ; restore rbx
	POP rdx ; restore rdx
	ret; return

polarity_loop:
	CALL select_polarity; calls (*curr_ptr == '+' || *curr_ptr == '-')
	CMP rax, 0;
	JE result_generation_loop;
	CMP byte [r8], 45; check if val of curr pointer is -
	JE call_flip_polarity ;if yes, run flip polarity 
	JNE clean_polarity_loop; if no, proceed with loop

call_flip_polarity:
	CALL flip_polarity; if yes, run flip polarity 

clean_polarity_loop:
	INC r8; increment r8
	JMP polarity_loop; jump to start of loop

result_generation:
	MOV rdi, r9; move base string into first arg for strlen
	CALL ft_strlen;
	MUL r10; multiple r10 with rax ////SETS RDX TO 0
	MOV r10, rax; move res of mult to r10
	MOV rsi, r8; move curr pointer to 2nd arg for char_in_base
	CALL char_in_base; call char_in_base
	SUB rax, r9; minus the result by base
	ADD r10, rax; add result to ret
	ret; return

result_generation_loop:
	MOV rdi, r9; move base string into first arg for char_in_base
	MOV rsi, r8; move curr pointer to 2nd arg for char_in_base
	CALL char_in_base; call char_in_base
	CMP rax, 0; compare res with 0
	JE clean_atoi_base; if equals, skip to clean
	CALL result_generation; if not equals, call res generation
	INC r8 ; increment curr pointer
	JMP result_generation_loop; jump to loop start

clean_atoi_base:
	; set up ret value
	MOV rax, r10; move r10 into retvalue
	MUL r11; multiple polarity with ret

	; stack frame cleanup
	POP rbp; restore prev bottom stack to register slot
	POP r11; restore r11
	POP r10; restore r10
	POP r9; restore r9
	POP r8; restore r8
	POP rsi; restore  2nd parameter to register
	POP rdi ; restore first parameter to register
	ret; return
