;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author:    JJ Brown
; Published: 2024-11-14
; License:   Free to reference for educational use.
;            Do not submit as your own work.
; Platform:  Linux, x86_64
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.global _start
.align 4

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

_start:
	; get ready to call a system function, by putting each input value into registers.
	; First we choose which system function to use:
	mov X16, #4  					; register X16 gets the ID of the syscall to execute, 4 is 'write'
	; Now that we've chosen 'print', we need to set the input values for the print function:
	mov X0, #1						; register X0 gets the output streem ID, 1 is stdout
	adr X1, STR_LIT_HELLO_WORLD     ; register X1 gets the address of the source string
	mov X2, #13 					; register X2 gets the length of the string, in bytes
	; The inputs are set, so we can tell the system to do a system call
	svc	#0x80 						; ask the system to execute the system call

	; now that we're done, we need to exit cleanly.
	; Select the system call 'exit':
	mov X16, #1 					; register X16 gets the Id of the syscall to execute, 1 is 'exit'
	; And set the "return code" to 0 to indicate this program finished successfully:
	mov X0, 0
	; And run the system call:
	svc	#0x80 						; ask the system to execute the system call


; variables go here
STR_LIT_HELLO_WORLD: .ascii "Hello World!\n"
