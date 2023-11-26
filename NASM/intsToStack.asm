section .data
msg db "Hello!", 10 ; 'Hello!' string plus newline 

section .text
global main

main:

; Allocate 20 bytes on stack 
sub rsp, 20

; Store values on stack
mov [rsp], dword 1  
mov [rsp + 4], dword 2
mov [rsp + 8], dword 3
mov [rsp + 12], dword 4
mov [rsp + 16], dword 5

; Print message
mov rax, 1
mov rdi, 1
mov rsi, msg 
mov rdx, 6
syscall

; Print values on stack 
mov rax, 1
mov rdi, 1
mov rsi, rsp
mov rdx, 20
syscall

; Exit
mov rax, 60
mov rdi, 0
syscall