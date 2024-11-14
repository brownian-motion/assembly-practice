global start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
	start:
	; get ready to call a system function, by putting each input value into registers.
	; First we choose which system function to use:
	mov rax, 4						; register rax gets the function ID, which is 4 for 'print'
	; Now that we've chosen 'print', we need to set the input values for the print function:
	mov rbx, 1           	 		; register rbx gets the output stream ID, which is 1 for stdout
	mov rcx, HELLO_WORLD_STR 		; register rcx gets the address of the string to print
	mov rdx, HELLO_WORLD_STR_SIZE 	; register rdx gets the SIZE of the string, in bytes
	; The inputs are set, so we can tell the system to "interrupt" our code and try to do a system call
	int 0x80

	; now that we're done, we need to exit cleanly.
	; Select the system call 'exit':
	mov rax, 1
	; And set the "return code" to 0 to indicate this program finished successfully:
	mov rbx, 0
	; And "interrupt" the code to do a system call:
	int 0x80

	; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
	ret

section .data
HELLO_WORLD_STR: DB 'Hello World!', 10        ; the '10' at the end adds on a newline '\n'
HELLO_WORLD_STR_SIZE: EQU $ - HELLO_WORLD_STR ; the size of the string is the CURRENT address (EQU) of HELLO_WORLD_STR_SIZE, minus the address of the string