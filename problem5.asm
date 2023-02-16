SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main

; Function: divisible_by_all
; args: (qword) number
; return:
;       RAX: 1 if divisible, 0 if not
divisible_by_all:
    push RBP
    mov RBP, RSP

    push 21 ; i, starting number
    push 1 ; default result

.loop:
    dec qword [RBP - 8] ; --i

    cmp qword [RBP - 8], 0 ; is i > 0?
    jle .return

    mov RAX, [RBP + 16]
    mov RDX, 0x0
    mov RCX, [RBP - 8]
    div RCX

    cmp RDX, 0x0
    jle .loop
    mov qword [RBP - 16], 0

.return:
    mov RAX, [RBP - 16]

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 20 ; i, starting number

.loop:
    push qword [RBP - 8]
    call divisible_by_all
    add RSP, 8 ; pop

    cmp RAX, 0x0
    jg .return
    inc qword [RBP - 8]
    jmp .loop

.return:
    mov RSI, [RBP - 8]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    leave
    ret

