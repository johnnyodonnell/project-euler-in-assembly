SECTION .rodata

fmt: db "%d", 0x0a, 0


SECTION .text

global main
extern printf

main:
    mov RBP, RSP
    push 0x3 ; iterator
    push 0x0 ; sum

modulo_3:
    ; Modulo: https://stackoverflow.com/a/8232170/5832619
    mov RAX, [RBP - 8]
    mov RCX, 0x3
    mov RDX, 0x0
    div RCX

    cmp RDX, 0x0
    jne modulo_5
    mov RAX, [RBP - 8]
    add [RBP - 16], RAX
    jmp loop_end

modulo_5:
    mov RAX, [RBP - 8]
    mov RCX, 0x5
    mov RDX, 0x0
    div RCX

    cmp RDX, 0x0
    jne loop_end
    mov RAX, [RBP - 8]
    add [RBP - 16], RAX

loop_end:
    mov RAX, [RBP - 8]
    inc RAX
    mov [RBP - 8], RAX

    ; https://www.aldeid.com/wiki/X86-assembly/Instructions/jl
    cmp RAX, 0x3e8
    jl modulo_3

    ; return result
    ; https://montcs.bloomu.edu/~bobmon/Code/Asm.and.C/Asm.Nasm/hello-printf-64.asm.html
    mov RSI, [RBP - 16]
    mov RDI, fmt
    mov RAX, 0x0
    ; https://stackoverflow.com/a/52131094/5832619
    call printf wrt ..plt

    ; exit program
    mov RBX, 0
    mov RAX, 0x1
    int 0x80

