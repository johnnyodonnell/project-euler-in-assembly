global _start

_start:
    mov EBP, ESP
    push 0x0 ; iterator
    push 0x0 ; sum

modulo_3:
    mov EAX, [EBP - 4]
    mov ECX, 0x3
    ; Modulo: https://stackoverflow.com/a/8232170/5832619
    mov EDX, 0x0
    div ECX

    cmp EDX,0x0
    jne modulo_5
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX
    jmp loop_end

modulo_5:
    mov EAX, [EBP - 4]
    mov ECX, 0x5
    mov EDX, 0x0
    div ECX

    cmp EDX,0x0
    jne loop_end
    mov EAX, [EBP - 4]
    add [EBP - 8], EAX

loop_end:
    mov EAX, [EBP - 4]
    inc EAX
    mov [EBP - 4], EAX

    ; https://www.aldeid.com/wiki/X86-assembly/Instructions/jl
    cmp EAX, 0x3e8
    jl modulo_3

    ; return result
    mov EBX,[EBP - 8]
    mov EAX, 0x1
    int 0x80

