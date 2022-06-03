# PURPOSE: finds the maximum value in an array.
#
# VARIABLES:
#   %rdi - holds the index
#   %rbx - hold current max
#   %rax - holds the value at index
#   
#   data_items - the array in memory

.section .data

data_items:
    .quad 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0

.section .text

.globl _start

_start:
    mov $0, %rdi
    mov data_items(, %rdi, 8), %rax
    mov %rax, %rbx

loop_start:
    cmp $0, %rax
    je end_loop
    inc %rdi
    mov data_items(, %rdi, 8), %rax
    cmp %rbx, %rax
    jle loop_start
    mov %rax, %rbx
    jmp loop_start

end_loop:
    mov $60, %rax   # exit
    mov %rbx, %rdi  # max as return value
    syscall
