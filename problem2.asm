SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main


main:
    push RBP
    mov RBP, RSP
    push 0x1 ; current fib
    push 0x1 ; previous fib
    push 0x0 ; sum

is_even:
    test qword [RBP - 8], 0x1
    jnz inc_and_loop
    mov RBX, [RBP - 8]
    add [RBP - 24], RBX

inc_and_loop:
    mov RBX, [RBP - 8] ; current fib
    mov R12, [RBP - 16] ; previous fib
    mov [RBP - 16], RBX
    add RBX, R12
    mov [RBP - 8], RBX

    cmp qword [RBP - 8], 0x3d0900 ; python3 -c "print(hex(4000000))"
    jle is_even

    mov RSI, [RBP - 24]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

