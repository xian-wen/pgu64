.include "linux.s"

.equ INTEGER_TO_BE_CONVERTED, 824

.section .data

# The length of the largest integer: len(str(2**64 - 1)) = 20
# plus the '\0'.
buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start

_start:
    mov %rsp, %rbp

    # Convert integer to string.
    push $buffer
    push $INTEGER_TO_BE_CONVERTED
    call integer2string
    add $16, %rsp

    # Get the length of the string.
    push $buffer
    call count_chars
    add $8, %rsp

    mov %rax, %rdx  # length as the size
    mov $SYS_WRITE, %rax
    mov $STDOUT, %rdi
    mov $buffer, %rsi
    syscall

    push $STDOUT
    call write_newline
    add $8, %rsp

    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
