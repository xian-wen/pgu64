.include "linux.s"

# PURPOSE:
#   prints "hello world" (no lib version).

# The length is equal to the difference between the address of 
# helloworld_end and of helloworld.
# No matter what helloworld_end is, the length is the same.
.equ HELLOWORLD_LEN, helloworld_end - helloworld

.section .data

helloworld:
    .ascii "hello world\n"

helloworld_end:

.section .text

.globl _start

_start:
    mov $SYS_WRITE, %rax
    mov $STDOUT, %rdi
    mov $helloworld, %rsi
    mov $HELLOWORLD_LEN, %rdx
    syscall

    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
