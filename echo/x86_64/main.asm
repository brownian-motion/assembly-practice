;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author:    JJ Brown
; Published: 2024-11-14
; License:   Free to reference for educational use.
;            Do not submit as your own work.
; Platform:  Linux, x86_64
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; assume implicit _start, complete with argv and argc
global _start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
    _start:

    ; int argc = *(int*)rsp
    mov rax, [rsp] ; System V convention, see https://stackoverflow.com/questions/52012290/how-to-get-argc-in-nasm-in-x64

    ; char** argv = (char**)(rsp + 8)
    mov rbx, rsp
    add rbx, 8

    add rbx, 8 ; skip printing the current executable path
    dec rax

print_argv_iter:
    ; char* arg = *argv
    mov rsi, [rbx]

    cmp rax, 0
    je do_exit

    push rax
    push rbx
        call strlen
        mov rdx, rax

        call println
    pop rbx
    pop rax

    add rbx, 8
    dec rax
    jmp print_argv_iter    

do_exit:
    mov rax, SYS_EXIT 
    mov rdi, 0
    syscall

    ; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;
; print     prints ONE decimal digit, stored in the lower nibble of rax
; INPUT     rsi
; OUTPUT    -
; CLOBBERS  rax, rdx, rdi
;;;;;;;;;;;;;;;;;;;;;;;;;;
printd_al: 
    push ax
        add al, '0'
        mov [printd_buffer], al
        mov rsi, printd_buffer
        mov rdx, 1
        call print
    pop ax
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;
; print
; INPUT     rsi, rdx
; OUTPUT    -
; CLOBBERS  rax, rdi
;;;;;;;;;;;;;;;;;;;;;;;;;;
print:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;
; println
; INPUT     rsi, rdx
; OUTPUT    -
; CLOBBERS  rax, rdx, rsi, rdi
;;;;;;;;;;;;;;;;;;;;;;;;;;
println:
    call print
    mov rsi, STR_LIT_NEWLINE
    mov rdx, 1
    call print

;;;;;;;;;;;;;;;;;;;;;;;;;;
; strlen
; INPUT     rsi
; OUTPUT    rax
; CLOBBERS  rbx 
;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen:
    mov rax, 0
strlen_iter:
    mov bl, BYTE [rsi + rax]
    cmp bl, 0
    jz strlen_ret
    inc rax
    jmp strlen_iter
strlen_ret:
    ret

section .rodata
SYS_READ    EQU 0
SYS_WRITE   EQU 1
SYS_EXIT    EQU 60

STDIN       EQU 0
STDOUT      EQU 1

STR_LIT_NEWLINE: db 10, 0 ; single newline with a null at the end

section .data
printd_buffer: db 0, 0