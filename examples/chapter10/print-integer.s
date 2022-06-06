.include "linux.s"

.equ ST_INTEGER, 16

.section .data

# The length of the largest integer: len(str(2**64 - 1)) = 20
# plus the '\0'.
buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl print_integer

.type print_integer, @function

print_integer:
    push %rbp
    mov %rsp, %rbp

    # Convert integer to string.
    push $buffer
    push ST_INTEGER(%rbp)
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

    mov %rbp, %rsp
    pop %rbp
    ret
