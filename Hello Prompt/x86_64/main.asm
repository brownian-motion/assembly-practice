global start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
	start:

print_prompt:
	; Print the prompt for the user
	mov rax, 4			; select 'print'
	mov rbx, 1 						; print to stdout (1)
	mov rcx, PROMPT_STR
	mov rdx, PROMPT_STR_SIZE
	int 0x80

read_input:
	; Ask the user for input.
	; Note that this uses different registers than 'print'!!
	mov rax, 0          			; select 'read'
	mov rdi, 0          			; read from stdin (0)
	mov rsi, [buffer]     			; where to store the data we read
	mov rdx, BUFFER_SIZE			; how many bytes to read, maximum!
	; execute the read....
	int 0x80
	; ... and get the real number of bytes read from rax
	mov [chars_read], rax

	; Then print everything we need to, part by part

print_prefix:
	mov rax, 4						; 'print'
	mov rbx, 1           	 		; to 'stdout'
	mov rcx, HELLO_WORLD_PREFIX 	; print the start of the "Hello _!" statement
	mov rdx, HELLO_WORLD_PREFIX_SIZE; ...which is THIS many bytes
	int 0x80						; do the syscall

print_name:
	mov rax, 4						; 'print'
	mov rbx, 1           	 		; to 'stdout'
	mov rcx, buffer 			 	; change our print source to the buffer full of user input
	mov rdx, [chars_read] 			; ...which is THIS many bytes
	int 0x80						; do the syscall

print_suffix:
	mov rax, 4						; 'print'
	mov rbx, 1           	 		; to 'stdout'
	mov rcx, HELLO_WORLD_SUFFIX	 	; change our print source to the end of the "Hello _!" statement
	mov rdx, HELLO_WORLD_SUFFIX_SIZE; ...which is THIS many bytes
	int 0x80						; do the syscall

do_exit:
	; now that we're done, we need to exit cleanly.
	; Select the system call 'exit':
	mov rax, 1
	; And set the "return code" to 0 to indicate this program finished successfully:
	mov rbx, 0
	; And "interrupt" the code to do a system call:
	int 0x80

	; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
	ret

section .rodata

HELLO_WORLD_PREFIX: DB 'Hello '
HELLO_WORLD_PREFIX_SIZE: EQU $ - HELLO_WORLD_PREFIX

HELLO_WORLD_SUFFIX: DB '!', 10 					; character 10 is '\n' the newline
HELLO_WORLD_SUFFIX_SIZE: EQU $ - HELLO_WORLD_SUFFIX

PROMPT_STR: DB 'Enter your name: '   		 	; No '\n' at the end, because I want the user to type at the end of the same line
PROMPT_STR_SIZE: EQU $ - PROMPT_STR

BUFFER_SIZE: EQU 20

section .bss
buffer: resb BUFFER_SIZE + 2				 	; Create an empty 20-byte buffer, with empty space at the end for nulls.
												; We aren't allowed to read more than this at once!
chars_read: resb 1								; We have to use 'resb' to reserve bytes, that way we can save data here later. 
												; If we used EQU instead, then the compiler just pastes its value and never reserves memory (inlining).
