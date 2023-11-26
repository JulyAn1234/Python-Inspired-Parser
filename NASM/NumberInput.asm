global main
extern printf, scanf

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ;body
    xor rax, rax
    lea rdi, [msg]
    call printf

    mov rax, 0
    lea rdi, [get_number_format]
    lea rsi, [number]
    call scanf

    mov eax, [number]
    add eax, 8
    mov [number], eax

    xor rax, rax
    mov rsi, [number]
    lea rdi, [get_number_format]
    call printf

    add rsp, 16
    leave
    ret

section .data
    msg: db "Hello, world!", 0xA, 0
    get_number_format: db "%d",0
    get_string_format: db "%s",0
    number: dd 0