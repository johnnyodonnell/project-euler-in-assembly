SECTION .rodata

; https://stackoverflow.com/a/38570/5832619
fmt: db "%lu", 0x0a, 0
number: db "73167176531330624919225119674426574742355349194934", \
           "96983520312774506326239578318016984801869478851843", \
           "85861560789112949495459501737958331952853208805511", \
           "12540698747158523863050715693290963295227443043557", \
           "66896648950445244523161731856403098711121722383113", \
           "62229893423380308135336276614282806444486645238749", \
           "30358907296290491560440772390713810515859307960866", \
           "70172427121883998797908792274921901699720888093776", \
           "65727333001053367881220235421809751254540594752243", \
           "52584907711670556013604839586446706324415722155397", \
           "53697817977846174064955149290862569321978468622482", \
           "83972241375657056057490261407972968652414535100474", \
           "82166370484403199890008895243450658541227588666881", \
           "16427171479924442928230863465674813919123162824586", \
           "17866458359124566529476545682848912883142607690042", \
           "24219022671055626321111109370544217506941658960408", \
           "07198403850962455444362981230987879927244284909188", \
           "84580156166097919133875499200524063689912560717606", \
           "05886116467109405077541002256983155200055935729725", \
           "71636269561882670428252483600823257530420752963450", 0


SECTION .text

extern printf
global main


MAX_DIGITS equ 13


; Function: main
main:
    push RBP
    mov RBP, RSP

    push 1 ; current value
    push 0 ; digits in value
    push 1 ; largest value

    lea R12, [rel number] ; i

.loop:
    mov R13, [R12]
    and R13, 0x00000000000000ff

    cmp R13, 0x0
    je .exit

    sub R13, 48

    cmp R13, 0x0 ; is num == 0 ?
    jg .unfilled_digits

    mov qword [RBP - 8], 1
    mov qword [RBP - 16], 0

    jmp .continue_loop

.unfilled_digits:
    cmp qword [RBP - 16], MAX_DIGITS ; are "digits in value" < MAX_DIGITS ?
    jge .calc_new_product

    mov RAX, [RBP - 8]
    mul R13
    mov [RBP - 8], RAX

    inc qword [RBP - 16]

    jmp .check_if_largest

.calc_new_product:
    mov RAX, [RBP - 8]
    mul R13

    mov R14, R12
    sub R14, MAX_DIGITS
    mov R14, [R14]
    and R14, 0x00000000000000ff
    sub R14, 48

    mov RDX, 0
    div R14

    mov [RBP - 8], RAX

.check_if_largest:
    mov RAX, [RBP - 8] ; RAX = current value
    cmp RAX, [RBP - 24] ; is "current value" > "largest value"?
    jle .continue_loop

    mov [RBP - 24], RAX

.continue_loop:
    inc R12
    jmp .loop

.exit:
    mov RSI, [RBP - 24]
    lea RDI, [rel fmt]
    mov RAX, 0x0
    call printf wrt ..plt

    mov RBX, 0
    mov RAX, 0x1
    int 0x80

