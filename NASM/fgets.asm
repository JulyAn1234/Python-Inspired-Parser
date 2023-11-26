section .data
    originalText resb 256  ; Assuming a buffer size of 256 bytes

section .text
    global main
    extern printf

main:
    ; Prepare parameters for my_fgets
    lea rdi, [originalText]  ; rdi = buffer address
    mov rsi, 256              ; rsi = buffer size
    xor rdx, rdx              ; rdx = file pointer (stdin)
    
    ; Call your custom fgets wrapper
    call my_fgets

    ; Your code continues here
    xor rax, rax
    lea rdi, [originalText]
    call printf



; Custom wrapper for fgets
my_fgets:
    ; Call fgets
    ; Signature: char *fgets(char *s, int size, FILE *stream);
    mov rax, 0       ; syscall number for sys_read
    mov rdi, rdi     ; rdi = buffer address
    mov rsi, rsi     ; rsi = buffer size
    mov rdx, rdx     ; rdx = file pointer (stdin)
    syscall
    ret