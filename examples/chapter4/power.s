# Computer 2^3 + 5^2 + 100^0.
#
# The return value of power stored in %rax.

.section .data

.section .text

.globl _start

_start:
    push $3
    push $2
    call power
    add $16, %rsp   # clear stack

    push %rax

    push $2
    push $5
    call power
    add $16, %rsp   # clear stack

    push %rax

    push $0
    push $100
    call power
    add $16, %rsp   # clear stack

    pop %rdi
    add %rax, %rdi
    pop %rax
    add %rax, %rdi  # power as return value

    mov $60, %rax   # exit
    syscall

# PURPOSE: calculate power: a^b.
# 
# INPUT:
#   base
#   exponent
#
# OUTPUT:
#   the result of base raise to the power of exponent - %rax
#
# VARIABLES:
#   %rdi - holds base
#   %rsi - holds exponent
#   %-8(%rbp) - holds current result
#   %rax - holds temp

.type power, @function

power:
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp
    
    mov 16(%rbp), %rdi
    mov 24(%rbp), %rsi
    movq $1, -8(%rbp)
    cmp $0, %rsi
    je end_power
    mov %rdi, -8(%rbp)

power_loop_start:
    cmp $1, %rsi
    je end_power
    mov -8(%rbp), %rax
    imul %rdi, %rax
    mov %rax, -8(%rbp)

    dec %rsi
    jmp power_loop_start

end_power:
    mov -8(%rbp), %rax
    mov %rbp, %rsp
    pop %rbp
    ret
