SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .data

; https://www.cs.virginia.edu/~evans/cs216/guides/x86.html
primes: dd 10001 DUP(0) ; array that will hold the first 10,0001 primes


SECTION .text

extern printf
global main


; Function: insert_prime
; args: (qword) index
;       (qword) prime to insert
; return: void
insert_prime:
    push RBP
    mov RBP, RSP

    mov RAX, [RBP + 16]
    mov RCX, 4
    mul RCX

    mov RDX, primes
    add RDX, RAX

    mov R12, [RBP + 24]
    mov [RDX], R12

    leave
    ret


; Function: fill_primes
; args: (qword) prime to try
; return:
;       RAX: 1 if prime, 0 if not
is_prime:
    push RBP
    mov RBP, RSP

    push 1 ; default return value

    mov R12, primes

.loop:
    cmp dword [R12], 0x0
    je .return

    mov RAX, [RBP + 16]
    mov RDX, 0x0

    xor RCX, RCX
    mov ECX, [R12]
    div RCX

    cmp RDX, 0x0
    je .not_prime

    add R12, 4
    jmp .loop

.not_prime:
    mov qword [RBP - 8], 0

.return:
    mov RAX, [RBP - 8]

    leave
    ret


; Function: fill_primes
; args: none
; return: void
fill_primes:
    push RBP
    mov RBP, RSP

    push 0 ; number of primes found
    push 2 ; current number to test for primeness

.loop:
    push qword [RBP - 16]
    call is_prime
    add RSP, 8 ; pop

    cmp RAX, 0x0
    je .continue

    push qword [RBP - 16]
    push qword [RBP - 8]
    call insert_prime
    add RSP, 16 ; pop

    inc qword [RBP - 8]

.continue:
    inc qword [RBP - 16] ; increment to next number to test for primeness

    cmp qword [RBP - 8], 10001 ; is number of primes found < 10001?
    jl .loop

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    call fill_primes

    mov RAX, 10000
    mov RCX, 4
    mul RCX
    mov RCX, RAX

    mov RAX, primes
    add RAX, RCX

    mov RSI, [RAX]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

