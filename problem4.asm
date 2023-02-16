SECTION .rodata

fmt: db "%d", 0x0a, 0
i: dw 999
j: dw 999


SECTION .text

extern printf
global main


; Function: exponent
; args = (qword) base
;        (qword) power
; return:
;       RAX: (qword) exponent
exponent:
    push RBP
    mov RBP, RSP

    push 1 ; default result

.loop:
    cmp qword [RBP + 24], 0x0 ; is power > 0?
    jle .return

    ; Multiply current result by base
    mov RAX, [RSP]
    mov RCX, [RBP + 16]
    mul RCX
    mov [RSP], RAX

    dec qword [RBP + 24] ; --power
    jmp .loop

.return:
    mov RAX, [RSP]

    leave
    ret


; Function: num_length
; args = (qword) number
; return:
;       RAX: (qword) length of number (number of decial digits)
num_length:
    push RBP
    mov RBP, RSP

    push 0 ; length
    mov RAX, [RBP + 16]

.loop:
    cmp RAX, 0x0
    jle .return
    inc qword [RSP]

    ; divide num by 10
    mov RDX, 0x0
    mov RCX, 10
    div RCX
    jmp .loop

.return:
    mov RAX, [RSP]

    leave
    ret


; Function: is_palindrome
; args = (qword) number to test
; return:
;       RAX: (qword) 1 if palindrome, 0 if not
is_palindrome:
    push RBP
    mov RBP, RSP

    push qword [RBP + 16]
    call num_length
    add RSP, 8 ; pop

    push RAX ; length of number

    ; divide length by 2
    mov RDX, 0x0
    mov RCX, 2
    div RCX

    push RAX ; i, number of iterations needed to test number
    push 0x1 ; result, assume true until proven otherwise

.loop:
    cmp qword [RBP - 16], 0x0 ; is i > 0?
    jle .return

    ; Find and push rightmost digit
    mov RAX, [RBP + 16]
    mov RDX, 0x0
    mov RCX, 10
    div RCX
    push RDX

    ; Find and push leftmost digit
    mov RAX, [RBP - 8]
    dec RAX
    push RAX
    push 10
    call exponent
    add RSP, 0x10 ; pop
    mov RCX, RAX

    mov RAX, [RBP + 16]
    mov RDX, 0x0
    div RCX

    mov RDX, 0x0
    mov RCX, 10
    div RCX
    push RDX

    ; Check if rightmost digit and leftmost digit are equal
    mov RAX, [RSP + 8] ; rightmost digit
    mov RCX, [RSP] ; leftmost digit
    cmp RAX, RCX
    je .continue_loop
    mov qword [RBP - 24], 0x0
    jmp .return

.continue_loop:
    add RSP, 0x10 ; pop rightmost and leftmost digits

    mov RAX, [RBP + 16]
    mov RDX, 0x0
    mov RCX, 10
    div RCX
    mov [RBP + 16], RAX

    sub qword [RBP - 8], 2 ; length -= 2
    dec qword [RBP - 16] ; --i

    jmp .loop

.return:
    mov RAX, [RBP - 24]

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 999 ; i = 999
    push 999 ; j = 999
    push 0 ; largest palindrome

.loop:
    ; multiply i * j
    mov RAX, [RBP - 8]
    mul qword [RBP - 16]
    push RAX

    push RAX
    call is_palindrome
    add RSP, 0x8 ; pop

    cmp RAX, 0x0
    je .continue_loop

    mov RAX, [RBP - 32]
    cmp RAX, [RBP - 24] ; is (i * j) > largest?
    jle .continue_loop

    mov [RBP - 24], RAX

.continue_loop:
    add RSP, 0x8 ; pop (i * j) from stack

    dec qword [RBP - 16] ; --j
    cmp qword [RBP - 16], 100
    jge .loop

    dec qword [RBP - 8] ; --i
    cmp qword [RBP - 8], 100
    mov qword [RBP - 16], 999 ; j = 999
    jge .loop

.return:
    mov RSI, [RBP - 24]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

