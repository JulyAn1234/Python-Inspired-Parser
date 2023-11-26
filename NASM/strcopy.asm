section .data
    source_string db "aaaaaaa", 0 ; Null-terminated string

section .bss
    copiedText resb 100 ; Allocate space for copiedText

section .text
    global main
    

main:
    ; Copy the string
    lea rdi, [copiedText] ; Destination (copiedText)
    lea rsi, [source_string] ; Source ("aaaaaaa")
    call strcpy

    ; Print the modified message
    xor rax, rax
    lea rdi, dword [rsp]
    call printf

    ; Exit the program
    mov eax, 0
    ret
