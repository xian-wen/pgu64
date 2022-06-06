.include "linux.s"
.include "record-def.s"

# PURPOSE:
#   reads a record from the file descriptor.
#
# INPUT:
#   file descriptor
#   buffer
#
# OUTPUT:
#   writes the data to the buffer and returns a status code.

.equ ST_READ_BUFFER, 16
.equ ST_FILE_DESCRIPTOR, 24

.globl read_record

.type read_record, @function

read_record:
    push %rbp
    mov %rsp, %rbp

    mov $SYS_READ, %rax
    mov ST_FILE_DESCRIPTOR(%rbp), %rdi
    mov ST_READ_BUFFER(%rbp), %rsi
    mov $RECORD_SIZE, %rdx
    syscall

    mov %rbp, %rsp
    pop %rbp
    ret
