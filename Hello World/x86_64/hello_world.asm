global _start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
	_start:
	; get ready to call a system function, by putting each input value into registers.
	; First we choose which system function to use:
	mov rax, SYS_WRITE				; register rax gets the function ID, which is 1 for 'print' on x86_64
	; Now that we've chosen 'print', we need to set the input values for the print function:
	mov rdi, STDOUT         		; register rbx gets the output stream ID, which is 1 for stdout
	mov rsi, HELLO_WORLD_STR 		; register rcx gets the address of the string to print
	mov rdx, HELLO_WORLD_STR_SIZE 	; register rdx gets the SIZE of the string, in bytes
	; The inputs are set, so we can tell the system to do a system call
	syscall

	; now that we're done, we need to exit cleanly.
	; Select the system call 'exit':
	mov rax, SYS_EXIT
	; And set the "return code" to 0 to indicate this program finished successfully:
	mov rdi, 0
	; And run the system call:
	syscall

	; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
	ret

section .data
; variables go here
HELLO_WORLD_STR: DB 'Hello World!', 10        ; the '10' at the end adds on a newline '\n'
HELLO_WORLD_STR_SIZE: EQU $ - HELLO_WORLD_STR ; the size of the string is the CURRENT address (EQU) of HELLO_WORLD_STR_SIZE, minus the address of the string

section .rodata
; constants go here
SYS_WRITE 	EQU 1
STDOUT 		EQU 1
SYS_EXIT 	EQU 60