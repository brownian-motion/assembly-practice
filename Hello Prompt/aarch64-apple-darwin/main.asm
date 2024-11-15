;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author:    JJ Brown
; Published: 2024-11-14
; License:   Free to reference for educational use.
;            Do not submit as your own work.
; Platform:  Linux, x86_64
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.global _start
.align  4

_start:

print_prompt:
	mov X16, #4 		  				; select the 'write' system call
	mov X0, #1 							; print to stdout
	adr X1, STR_LIT_PROMPT				; the string to print
	mov X2, #17 			 			; length of the string
	svc #80 

read_str:
	mov X16, #3 						; select the 'read' system call
	mov X0, #0 							; read from stdin
	adrp X1, buffer@page 				; read into buffer
	add X1, X1, buffer@PAGEOFF
	mov X2, #20
	svc #80
	; the bytecount of how much was read is stored in X1. Save that in X3
	mov X3, X0

print_prefix:
	mov X16, #4 		  				; select the 'write' system call
	mov X0, #1 							; print to stdout
	adr X1, STR_LIT_HELLO_PREFIX		; the string to print
	mov X2, #6 						 	; length of the string
	svc #80 

print_buffer:
	mov X16, #4 		  				; select the 'write' system call
	mov X0, #1 							; print to stdout
	adrp X1, buffer@page 				; read into buffer
	add X1, X1, buffer@PAGEOFF
	mov X2, X3 						 	; length of the string
	svc #80 

print_suffix:
	mov X16, #4 		  				; select the 'write' system call
	mov X0, #1 							; print to stdout
	adr X1, STR_LIT_HELLO_SUFFIX		; the string to print
	mov X2, #2 						 	; length of the string
	svc #80 

	
STR_LIT_PROMPT: 				.ascii "Enter your name: "
STR_LIT_HELLO_PREFIX: 			.ascii "Hello "
STR_LIT_HELLO_SUFFIX: 			.ascii "!\n"

.data
.align 2
buffer: .space 1024
