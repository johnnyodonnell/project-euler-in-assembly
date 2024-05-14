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
    push 0x0 ; sum
    push 0x1 ; first num
    push 0x1 ; second num

loop_start:
    ; calculate next fibonacci number
    mov EBX, [EBP - 8]
    add EBX, [EBP - 12]

    ; update num variables
    mov EDI, [EBP - 12]
    mov [EBP - 8], EDI
    mov [EBP - 12], EBX

    cmp EBX, 0x3D0900 ; 4,000,000 ; 0x64 ; 100
    jg loop_end

    ; mod 2
    push 0x2
    push EBX
    call modulo
    add ESP, 8 ; pop

    cmp EAX, 0x0
    jne loop_start
    add [EBP - 4], EBX
    jmp loop_start

loop_end:
    push DWORD [EBP - 4]
    lea EAX, [rel fmt]
    push EAX
    call printf wrt ..plt

    ; exit program
    mov EBX, 0
    mov EAX, 0x1
    int 0x80

