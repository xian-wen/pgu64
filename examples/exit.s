# PURPOSE: simple program exit and return a status code. 
#
# VARIABLES:
#   %rax - holds the system call number
#   %rbx - holds the return value

.section .data

.section .text
.globl _start

_start:
    movq $60, %rax  # exit

    movq $0, %rdi

    syscall
