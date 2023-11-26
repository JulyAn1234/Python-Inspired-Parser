global main
extern printf, scanf

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 64  ; Adjust the stack size based on your needs

    ; Prompt user for input
    lea rdi, [get_string_format]
    lea rsi, dword [rsp]
    call scanf

    ; Print the modified message
    xor rax, rax
    lea rdi, dword [rsp]
    call printf

    add rsp, 64
    leave
    ret

section .data
    msg: db 256 dup(0)  ; Reserve 256 bytes for the string
    get_number_format: db "%d", 0
    get_string_format: db "%s", 0
    number: dd 0
