SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

extern printf
global main

modulo:
    push RBP
    mov RBP, RSP

    mov RAX, [RBP + 16] ; left operand
    mov RCX, [RBP + 24] ; right operand
    mov RDX, 0x0
    div RCX

    mov RAX, RDX

    leave
    ret


main:
    mov RBP, RSP
    push 0x0 ; iterator
    push 0x0 ; sum

modulo_3:
    ; Modulo: https://stackoverflow.com/a/8232170/5832619
    push 0x3
    push qword [RBP - 8]
    call modulo
    add RSP, 16 ; pop

    cmp RAX, 0x0
    jne modulo_5
    mov RAX, [RBP - 8]
    add [RBP - 16], RAX
    jmp loop_end

modulo_5:
    push 0x5
    push qword [RBP - 8]
    call modulo
    add RSP, 16 ; pop

    cmp RAX, 0x0
    jne loop_end
    mov RAX, [RBP - 8]
    add [RBP - 16], RAX

loop_end:
    inc qword [RBP - 8]

    ; https://www.aldeid.com/wiki/X86-assembly/Instructions/jl
    cmp qword [RBP - 8], 0x3e8
    jl modulo_3

    ; return result
    ; https://montcs.bloomu.edu/~bobmon/Code/Asm.and.C/Asm.Nasm/hello-printf-64.asm.html
    mov RSI, [RBP - 16]

    ; A comment in this SO question:
    ; https://stackoverflow.com/q/34288482/5832619
    ; led me to use "lea RDI, [rel fmt]" instead of
    ; "mov RDI, fmt" in order to make this program
    ; position independent
    lea RDI, [rel fmt]

    mov RAX, 0x0
    ; https://stackoverflow.com/a/52131094/5832619
    call printf wrt ..plt

    ; exit program
    mov RBX, 0
    mov RAX, 0x1
    int 0x80

