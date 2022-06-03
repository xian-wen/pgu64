# PURPOSE: simple program exit and return a status code. 
#
# VARIABLES:
#   %rax - holds the system call number
#   %rdi - holds the return value

.section .data

.section .text

.globl _start

_start:
    mov $60, %rax  # exit
    mov $0, %rdi
    syscall
