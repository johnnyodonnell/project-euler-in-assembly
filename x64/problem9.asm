SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main


; Function: square
; args: (qword) num
; return:
;       RAX: (qword) num squared
square:
    push RBP
    mov RBP, RSP

    mov RAX, [RBP + 16]
    mov RCX, [RBP + 16]
    mul RCX

    leave
    ret


; Function: is_pythagorean_triplet
; args: (qword) a
;       (qword) b
;       (qword) c
; return:
;       RAX: (qword) 1 if triplet, 0 if not
is_pythagorean_triplet:
    push RBP
    mov RBP, RSP

    push 0 ; default return value

    ; calculate c^2 and save as local variable
    push qword [RBP + 32]
    call square
    add RSP, 8 ; pop
    push RAX

    ; calculate b^2 and subtract from c^2
    push qword [RBP + 24]
    call square
    add RSP, 8 ; pop
    sub [RBP - 16], RAX

    ; calculate a^2 and subtract from c^2
    push qword [RBP + 16]
    call square
    add RSP, 8 ; pop
    sub [RBP - 16], RAX

    cmp qword [RBP - 16], 0x0
    jne .return

    mov qword [RBP - 8], 1

.return:
    mov RAX, [RBP - 8]

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 0 ; a (placeholder)
    push 0 ; b (placeholder)

.outer_loop:
    inc qword [RBP - 8]

    cmp qword [RBP - 8], 500
    jge .return

    ; set b to a
    mov RAX, [RBP - 8]
    mov [RBP - 16], RAX

.inner_loop:
    inc qword [RBP - 16]

    cmp qword [RBP - 16], 500
    jge .outer_loop

    mov RAX, [RBP - 8]
    add RAX, [RBP - 16]
    cmp RAX, 1000
    jge .outer_loop

    ; calculate c (c = 1000 - (a + b))
    mov RCX, 1000
    sub RCX, RAX
    push RCX ; save c as local variable

    push RCX
    push qword [RBP - 16]
    push qword [RBP - 8]
    call is_pythagorean_triplet
    add RSP, 24 ; pop

    cmp RAX, 0x0
    jg .return

    add RSP, 8 ; clear local variable c
    jmp .inner_loop

.return:
    mov RAX, [RBP - 8] ; a
    mov RCX, [RBP - 16] ; b
    mul RCX
    mov RCX, [RBP - 24] ; c
    mul RCX

    mov RSI, RAX
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

