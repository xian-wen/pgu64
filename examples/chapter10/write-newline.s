.include "linux.s"

# PURPOSE:
#   adds a newline to the file descriptor.
#
# INPUT:
#   file descriptor
#
# OUTPUT:
#   returns a status code.

.equ ST_FILE_DESCRIPTOR, 16

.section .data

newline:
    .ascii "\n"

.section .text

.globl write_newline

.type write_newline, @function

write_newline:
    push %rbp
    mov %rsp, %rbp

    mov $SYS_WRITE, %rax
    mov ST_FILE_DESCRIPTOR(%rbp), %rdi
    mov $newline, %rsi
    mov $1, %rdx
    syscall

    mov %rbp, %rsp
    pop %rbp
    ret
