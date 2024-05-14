SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main

modulo:
    push EBP
    mov EBP, ESP

    mov EAX, [EBP + 8] ; left operand
    mov ECX, [EBP + 12] ; right operand
    mov EDX, 0x0
    div ECX

    mov EAX, EDX

    leave
    ret


main:
    mov EBP, ESP
    push 0x0 ; iterator
    push 0x0 ; sum

modulo_3:
    push 0x3
    push DWORD [EBP - 4]
    call modulo
    add ESP, 8 ; pop

    cmp EAX, 0x0
    jne modulo_5
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX
    jmp loop_end

modulo_5:
    push 0x5
    push DWORD [EBP - 4]
    call modulo
    add ESP, 8 ; pop

    cmp EAX, 0x0
    jne loop_end
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX

loop_end:
    inc DWORD [EBP - 4]

    cmp DWORD [EBP - 4], 0x3e8 ; cmp iterator 1000
    jl modulo_3

    push DWORD [EBP - 8]
    lea EAX, [rel fmt]
    push EAX
    call printf wrt ..plt

    ; exit program
    mov EBX, 0
    mov EAX, 0x1
    int 0x80

