.include "linux.s"
.include "record_def.s"

# PURPOSE:
#   print on the terminal the names of the records in a file.

.equ ST_SIZE_RESERVE, 16
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

.section .data

filename:
    .ascii "test.dat\0"

.section .bss

.lcomm RECORD_BUFFER, RECORD_SIZE

.section .text

.globl _start

_start:
    mov %rsp, %rbp
    sub $ST_SIZE_RESERVE, %rsp

    mov $SYS_OPEN, %rax
    mov $filename, %rdi
    mov $O_RDONLY, %rsi
    mov $PERMISSION, %rdx
    syscall

    mov %rax, ST_INPUT_DESCRIPTOR(%rbp)
    movq $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)

record_read_loop:
    # Read a record.
    push ST_INPUT_DESCRIPTOR(%rbp)
    push $RECORD_BUFFER
    call read_record
    add $16, %rsp

    cmp $RECORD_SIZE, %rax
    jne end_read

    # Get the length of the record name.
    push $RECORD_BUFFER + RECORD_FIRSTNAME
    call count_chars
    add $8, %rsp

    # Print record name on the terminal.
    mov %rax, %rdx  # length as the buffer size
    mov $SYS_WRITE, %rax
    mov ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
    mov $RECORD_BUFFER + RECORD_FIRSTNAME, %rsi
    syscall

    # Print newline on the terminal.
    push ST_OUTPUT_DESCRIPTOR(%rbp)
    call write_newline
    add $8, %rsp

    jmp record_read_loop

end_read:
    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
