# PURPOSE: compute 4!.
# 
# The return value is stored in %rax.

.section .data

.section .text

.globl _start

_start:
    push $4
    call factorial
    add $8, %rsp    # clear stack

    mov %rax, %rdi  # factorial as return value
    mov $60, %rax   # exit
    syscall


# PURPOSE: calculate factorial: n!
#
# INPUT:
#   a number
#
# OUTPUT:
#   its factorial
#
# VARIABLES:
#   %rax - fact(n - 1)
#   %rbx - n

.type factorial, @function

factorial:
    push %rbp
    mov %rsp, %rbp

    mov 16(%rbp), %rax
    cmp $1, %rax
    je end_factorial

    dec %rax
    push %rax
    call factorial

    mov 16(%rbp), %rbx
    imul %rbx, %rax

end_factorial:
    mov %rbp, %rsp
    pop %rbp
    ret
