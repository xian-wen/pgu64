.include "linux.s"
.include "record_def.s"

.equ ST_SIZE_RESERVE, 16
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

.section .data

input_filename:
    .ascii "test.dat\0"

output_filename:
    .ascii "testout.dat\0"

.section .bss

.lcomm RECORD_BUFFER, RECORD_SIZE

.section .text

.globl _start

_start:
    mov %rsp, %rbp
    sub $ST_SIZE_RESERVE, %rsp

    mov $SYS_OPEN, %rax
    mov $input_filename, %rdi
    mov $O_RDONLY, %rsi
    mov $PERMISSION, %rdx
    syscall

    mov %rax, ST_INPUT_DESCRIPTOR(%rbp)

    mov $SYS_OPEN, %rax
    mov $output_filename, %rdi
    mov $O_CREAT_WRONLY, %rsi
    mov $PERMISSION, %rdx
    syscall

    mov %rax, ST_OUTPUT_DESCRIPTOR(%rbp)

loop_begin:
    push ST_INPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call read_record
    add $16, %rsp

    cmp $RECORD_SIZE, %rax
    jne end_loop

    incq RECORD_BUFFER + RECORD_AGE

    push ST_OUTPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call write_record
    add $16, %rsp

    jmp loop_begin

end_loop:
    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
