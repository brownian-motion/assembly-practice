;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author:    JJ Brown
; Published: 2024-11-14
; License:   Free to reference for educational use.
;            Do not submit as your own work.
; Platform:  Linux, x86_64
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


global _start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
    _start:
;     mov rax, 0x20

; loop:
;     cmp rax, 0x7F
;     jge do_exit

;     push rax
;     call capital_char_rax
;     mov [chr], rax
;     call print_chr
;     pop rax
;     inc rax
;     jmp loop

read_chr:
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, chr
    mov rdx, 1
    syscall

handle_eof:
    cmp ax, 0 ; if the number of chars read is 0, exit
    je do_exit
    mov ax, [chr]
    cmp ax, 0 ; if we just read a null terminator, exit
    je do_exit

call_capitalize:
    mov ax, [chr]
    call capital_char_rax
    mov [chr], ax

print_rax:
    ; mov [chr], rax
    call print_chr

    jmp read_chr

do_exit:
    mov rax, SYS_EXIT 
    mov rdi, 0
    syscall

    ; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
    ret

capital_char_rax:
    push bx
    mov bx, ax
    cmp ax, LOWER_A
    jb capital_char_rax_ret
    mov ax, bx
    cmp ax, LOWER_Z
    ja capital_char_rax_ret
    mov ax, bx
    and ax, 0xDF
capital_char_rax_ret:
    pop bx
    ret

print_chr:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, chr
    mov rdx, 1
    syscall
    ret

; capital_ptr_rax:
;     cmp rax, 0x60
;     jle capital_ptr_rax_ret
;     cmp rax, 0x7B
;     jge capital_ptr_rax_ret
;     sub rax, 0x20
; capital_ptr_rax_ret:
;     ret

section .rodata
SYS_READ    EQU 0
SYS_WRITE   EQU 1
SYS_EXIT    EQU 60

STDIN       EQU 0
STDOUT      EQU 1

BUFFER_SIZE: EQU 20

section .data
chr: db 0, 0 ; initialize with a null at the end


LOWER_A:   EQU 0x61
LOWER_Z:   EQU 0x7A