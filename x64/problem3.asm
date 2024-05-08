SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main


; Function: find_next_prime
; args: (*qword) next prime to try
;       (qword) target num
; return:
;       RAX: (qword) prime found
find_next_prime:
    push RBP
    mov RBP, RSP

    mov RBX, [RBP + 16] ; get pointer to next prime to try
    mov RBX, [RBX] ; get next prime to try

; https://stackoverflow.com/a/2406154/5832619
.loop:
    cmp RBX, [RBP + 24]
    jg .return

    ; modulo
    mov RAX, [RBP + 24] ; dividend lower bits
    mov RDX, 0x0 ; dividend upper bits
    mov R12, RBX ; divisor
    div R12
    cmp RDX, 0x0
    jz .return
    inc RBX
    jmp .loop

.return:
    mov R12, [RBP + 16] ; get pointer to next prime to try
    mov [R12], RBX

    leave
    ret


; Function: main
main:
    push RBP
    mov RBP, RSP

    ; https://stackoverflow.com/a/3623974/5832619
    mov RBX, 0x8be589eac7 ; target num: python3 -c "print(hex(600851475143))"
    push RBX

    push 2 ; next prime to try

.loop:
    cmp qword [RBP - 8], 1 ; is target num > 1?
    jle .print_result
    push qword [RBP - 8] ; target num
    lea RBX, [RBP - 16] ; pointer to next prime to try
    push RBX
    call find_next_prime
    add RSP, 0x10 ; pop

    ; divide target by current prime
    mov RAX, [RBP - 8] ; dividend lower bits
    mov RDX, 0x0 ; divident upper bits
    mov RBX, [RBP - 16] ; divisor
    div RBX
    mov [RBP - 8], RAX

    jmp .loop

.print_result:
    mov RSI, [RBP - 16]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

