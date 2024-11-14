global _start

; there are 4 major sections:
; .data contains global variables (whose initial value we specify)
; .rodata is read-only data. These are constants.
; .bss is ALSO for global variables (but the initial value is not set)
; .text contains the executable code

section .text
    _start:

print_prompt:
    ; Print the prompt for the user
    mov rax, SYS_WRITE              ; select 'print' (id 1)
    mov rdi, STDOUT                 ; write to stdout (1)
    mov rsi, PROMPT_STR
    mov rdx, PROMPT_STR_SIZE
    syscall

read_input:
    ; Ask the user for input.
    mov rax, SYS_READ               ; select 'read' (id 0)
    mov rdi, STDIN                  ; read from stdin (0)
    mov rsi, buffer                 ; where to store the data we read
    mov rdx, BUFFER_SIZE            ; how many bytes to read, maximum!
    ; execute the read....
    syscall
    ; ... put a null terminator at the end of the string...
    mov byte [rsi+rax], 0
    ; ... and get the real number of bytes read from rax
    mov [chars_read], rax           ; store the contents of rax at address 'chars_read'

    ; Then print everything we need to, part by part

print_prefix:
    mov rax, SYS_WRITE              ; 'print'
    mov rdi, STDOUT                 ; to 'stdout'
    mov rsi, HELLO_WORLD_PREFIX     ; print the start of the "Hello _!" statement
    mov rdx, HELLO_WORLD_PREFIX_SIZE; ...which is THIS many bytes
    syscall                         ; do the syscall

print_name:
    mov rax, SYS_WRITE              ; 'print'
    mov rdi, STDOUT                 ; to 'stdout'
    mov rsi, buffer                 ; change our print source to the buffer full of user input
    mov rdx, [chars_read]           ; ...which is THIS many bytes
    syscall                         ; do the syscall

print_suffix:
    mov rax, SYS_WRITE              ; 'print'
    mov rdi, STDOUT                 ; to 'stdout'
    mov rsi, HELLO_WORLD_SUFFIX     ; change our print source to the end of the "Hello _!" statement
    mov rdx, HELLO_WORLD_SUFFIX_SIZE; ...which is THIS many bytes
    syscall                         ; do the syscall

do_exit:
    ; now that we're done, we need to exit cleanly.
    ; Select the system call 'exit':
    mov rax, SYS_EXIT 
    ; And set the "return code" to 0 to indicate this program finished successfully:
    mov rdi, 0
    syscall

    ; We're done with the full program, so if we reach this line, just "return" instead of continuing into garbage memory and running that as code.
    ret

section .rodata
SYS_READ    EQU 0
SYS_WRITE   EQU 1
SYS_EXIT    EQU 60

STDIN       EQU 0
STDOUT      EQU 1

HELLO_WORLD_PREFIX: DB 'Hello '
HELLO_WORLD_PREFIX_SIZE: EQU $ - HELLO_WORLD_PREFIX

HELLO_WORLD_SUFFIX: DB '!', 10                  ; character 10 is '\n' the newline
HELLO_WORLD_SUFFIX_SIZE: EQU $ - HELLO_WORLD_SUFFIX

PROMPT_STR: DB 'Enter your name: '              ; No '\n' at the end, because I want the user to type at the end of the same line
PROMPT_STR_SIZE: EQU $ - PROMPT_STR

BUFFER_SIZE: EQU 20

section .bss
buffer: resb BUFFER_SIZE + 2                    ; Create an empty 20-byte buffer, with empty space at the end for nulls.
                                                ; We aren't allowed to read more than this at once!
chars_read: resb 1                              ; We have to use 'resb' to reserve bytes, that way we can save data here later. 
                                                ; If we used EQU instead, then the compiler just pastes its value and never reserves memory (inlining).
