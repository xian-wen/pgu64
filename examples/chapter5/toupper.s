# PURPOSE: 
#   convert an input file to an output file
#   with lower case to upper case.

.section .data

.equ SYS_OPEN, 2
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_CLOSE, 3
.equ SYS_EXIT, 60

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101
.equ PERMISSION, 0666

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ END_OF_FILE, 0
.equ NUMBER_ARGUMENTS, 2

.section .bss

.equ BUFFER_SIZE, 1024
.lcomm BUFFER, BUFFER_SIZE

.section .text

.equ ST_SIZE_RESERVE, 16
.equ ST_FD_IN, -8
.equ ST_FD_OUT, -16
.equ ST_ARGC, 0     # Number of arguments
.equ ST_ARGV_0, 8   # Name of the program
.equ ST_ARGV_1, 16  # Input file name
.equ ST_ARGV_2, 24  # Output file name

.globl _start

_start:
    mov %rsp, %rbp
    sub $ST_SIZE_RESERVE, %rsp

# VARIABLES:
#   %rax - system call
#   %rdi - first argument
#   %rsi - second argument
#   %rdx - third argument

open_files:
open_fd_in:
    mov $SYS_OPEN, %rax
    mov ST_ARGV_1(%rbp), %rdi
    mov $O_RDONLY, %rsi
    mov $PERMISSION, %rdx
    syscall    

store_fd_in:
    mov %rax, ST_FD_IN(%rbp)

open_fd_out:
    mov $SYS_OPEN, %rax
    mov ST_ARGV_2(%rbp), %rdi
    mov $O_CREAT_WRONLY_TRUNC, %rsi
    mov $PERMISSION, %rdx
    syscall

store_fd_out:
    mov %rax, ST_FD_OUT(%rbp)


read_loop_begin:
    mov $SYS_READ, %rax
    mov ST_FD_IN(%rbp), %rdi
    mov $BUFFER, %rsi
    mov $BUFFER_SIZE, %rdx
    syscall

    cmp $END_OF_FILE, %rax
    jle end_loop

continue_read_loop:
    push $BUFFER
    push %rax     # push number of bytes read
    call convert_to_upper
    pop %rax      # get the size back
    add $8, %rsp  # clear stack

    mov %rax, %rdx
    mov $SYS_WRITE, %rax
    mov ST_FD_OUT(%rbp), %rdi
    mov $BUFFER, %rsi
    syscall

    jmp read_loop_begin

end_loop:
    mov $SYS_CLOSE, %rax
    mov ST_FD_OUT(%rbp), %rdi
    syscall

    mov $SYS_CLOSE, %rax
    mov ST_FD_IN(%rbp), %rdi
    syscall

    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
    

# PURPOSE: 
#   Convert lower case letters in the buffer to upper case.
#
# INPUT:
#   bufer
#   bufer size
#
# OUTPUT:
#   converted buffer
#
# VARIABLES:
#   %rax - buffer
#   %rbx - buffer size
#   %rdi - current offset
#   %cl - current byte

.equ LOWER_CASE_A, 'a'
.equ LOWER_CASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_SIZE, 16
.equ ST_BUFFER, 24

convert_to_upper:
    push %rbp
    mov %rsp, %rbp

    mov ST_BUFFER(%rbp), %rax
    mov ST_BUFFER_SIZE(%rbp), %rbx
    mov $0, %rdi

    cmp $0, %rbx
    je end_convert_loop

convert_loop:
    mov (%rax, %rdi, 1), %cl

    cmp $LOWER_CASE_A, %cl
    jl next_byte
    cmp $LOWER_CASE_Z, %cl
    jg next_byte

    add $UPPER_CONVERSION, %cl
    mov %cl, (%rax, %rdi, 1)

next_byte:
    inc %rdi
    cmp %rdi, %rbx
    jne convert_loop

end_convert_loop:
    mov %rbp, %rsp
    pop %rbp
    ret
