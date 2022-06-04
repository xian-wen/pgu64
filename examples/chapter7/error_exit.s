.include "linux.s"

.equ ST_ERROR_CODE, 16
.equ ST_ERROR_MSG, 24

.globl error_exit

.type error_exit, @function

error_exit:
    push %rbp
    mov %rsp, %rbp

    # Get the length of the error code.
    push ST_ERROR_CODE(%rbp)
    call count_chars
    add $8, %rsp

    mov %rax, %rdx  # length as the size
    mov $SYS_WRITE, %rax
    mov $STDERR, %rdi
    mov ST_ERROR_CODE(%rbp), %rsi
    syscall

    # Get the length of the error message.
    push ST_ERROR_MSG(%rbp)
    call count_chars
    add $8, %rsp

    mov %rax, %rdx  # length as the size
    mov $SYS_WRITE, %rax
    mov $STDERR, %rdi
    mov ST_ERROR_MSG(%rbp), %rsi
    syscall

    push $STDERR
    call write_newline
    add $8, %rsp

    mov $SYS_EXIT, %rax
    mov $1, %rdi
    syscall
