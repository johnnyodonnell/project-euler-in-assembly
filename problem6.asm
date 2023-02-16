SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main


; Function: square
; args: (qword) base
; return:
;       RAX: base ^ 2
square:
    push RBP
    mov RBP, RSP

    mov RAX, [RBP + 16]
    mov RCX, [RBP + 16]
    mul RCX

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 1 ; i, first natrual number
    push 0 ; sum
    push 0 ; sum of squares

.loop:
    cmp qword [RBP - 8], 101
    jge .return

    mov RAX, [RBP - 8]
    add [RBP - 16], RAX

    push RAX
    call square
    add RSP, 8 ; pop

    add [RBP - 24], RAX

    inc qword [RBP - 8]
    jmp .loop

.return:
    push qword [RBP - 16]
    call square
    add RSP, 8 ; pop

    sub RAX, [RBP - 24]

    mov RSI, RAX
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

