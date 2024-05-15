SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

; https://blog.code-cop.org/2015/07/hello-world-windows-32-assembly.html
extern _ExitProcess@4
extern _GetStdHandle@4
extern _WriteFile@20
global main

print_digit:
    push EBP
    mov EBP, ESP

    push 0x0 ; bits to shift
    xor EBX, EBX ; zero out EBX

.loop_start:
    mov EAX, [EBP + 12] ; move digit into EAX
    mov CL, [EBP - 4]
    shr EAX, CL
    and EAX, 0xF ; clear upper bits

    add DWORD [EBP - 4], 0x4

    cmp EAX, 0xA ;
    jl .loop_continue
    add EAX, 0x7
.loop_continue:
    add EAX, 0x30

    shl EBX, 0x8
    mov BL, AL

    cmp DWORD [EBP - 4], 0x10 ; 16
    jnz .is_shift_zero

    push EBX
    xor EBX, EBX ; zero out EBX again

.is_shift_zero:
    cmp DWORD [EBP - 4], 0x20 ; 32
    jl .loop_start

.loop_end:
    push EBX

    push -11
    call _GetStdHandle@4
    ; For some reason this function cleans up the argument for us
    ; add ESP, 0x4 ; pop
    mov EBX, EAX

    ; bytes written
    push 0
    lea EAX, [ESP]

    push 0 ; null
    push EAX
    push 0x8 ; print N bytes
    lea EAX, [EBP - 12]
    push EAX
    push EBX
    call _WriteFile@20

    leave
    ret


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

.modulo_3:
    push 0x3
    push DWORD [EBP - 4]
    call modulo
    add ESP, 8 ; pop

    cmp EAX, 0x0
    jne .modulo_5
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX
    jmp .loop_end

.modulo_5:
    push 0x5
    push DWORD [EBP - 4]
    call modulo
    add ESP, 8 ; pop

    cmp EAX, 0x0
    jne .loop_end
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX

.loop_end:
    inc DWORD [EBP - 4]

    cmp DWORD [EBP - 4], 0x3e8 ; cmp iterator 1000
    jl .modulo_3

    push DWORD [EBP - 8]
    call print_digit

    ; exit program
    push 0
    call _ExitProcess@4

