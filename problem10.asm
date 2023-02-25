SECTION .rodata

fmt: db "%lu", 0x0a, 0


SECTION .text

extern printf
global main


; Function: sqrt_ceil
; args: (qword) num
; return:
;       RAX: (qword) ceiling of the square root of num
sqrt_ceil:
    push RBP
    mov RBP, RSP

    push 1 ; i

.loop:
    mov RAX, [RBP - 8]
    mov RCX, [RBP - 8]
    mul RCX

    cmp RAX, [RBP + 16]
    jge .return

    inc qword [RBP - 8]
    jmp .loop

.return:
    mov RAX, [RBP - 8]

    leave
    ret


; Function: is_prime
; args: (qword) num to test for primeness
; return:
;       RAX: (qword) 1 if prime, 0 if not
is_prime:
    push RBP
    mov RBP, RSP

    push qword [RBP + 16]
    call sqrt_ceil
    add RSP, 8 ; pop

    push RAX ; sqrt_ceil of num
    push 0x1 ; default return value

    mov R8, [RBP + 24]

.loop:
    mov RAX, [RBP - 8]
    cmp qword [R8], RAX
    jg .return

    cmp qword [R8], 0x0
    je .return

    mov RAX, [RBP + 16]
    mov RDX, 0x0
    mov RCX, [R8]
    div RCX

    cmp RDX, 0x0
    je .not_prime

    sub R8, 8
    jmp .loop

.not_prime:
    mov qword [RBP - 16], 0x0

.return:
    mov RAX, [RBP - 16]

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 2 ; sum
    push 3 ; i, num to test for primeness
    push 2 ; First element in array of known primes

.loop:
    cmp qword [RBP - 16], 0x1e8480 ; 2,000,000 in hex
    jge .return

    push 0x0 ; push null character to mark end of array of known primes
    lea RAX, [RBP - 24]
    push RAX ; push address of array of known primes
    push qword [RBP - 16] ; push i
    call is_prime
    add RSP, 24 ; pop

    cmp RAX, 0x0
    je .continue_loop

    ; add to list of known primes
    push qword [RBP - 16]
    ; add to sum
    mov RAX, [RBP - 16]
    add [RBP - 8], RAX

.continue_loop:
    inc qword [RBP - 16] ; increment i
    jmp .loop

.return:
    mov RSI, [RBP - 8]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

