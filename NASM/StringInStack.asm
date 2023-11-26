global main
extern printf, scanf

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rax, 'a test.'
    push rax
    mov rax, 'this is '
    push rax

    mov edx, 15
    lea rsi, [rsp]
    mov edi, 1
    mov eax, 1
    syscall

    pop rax
    pop rax

    add rsp, 16
    sub rsp, 20

    mov [rsp], dword 1  
    mov [rsp + 4], dword 2
    mov [rsp + 8], dword 3
    mov [rsp + 12], dword 4
    mov [rsp + 16], dword 5

    xor rax, rax
    mov rdi, [rsp + 4]
    lea rsi, [get_number_format]
    call printf    

    add rsp, 20
    leave
    ret

section .data
    msg: db "Hello, world!", 0xA, 0
    get_number_format: db "%d",0
    get_string_format: db "%s",0
    number: dd 0