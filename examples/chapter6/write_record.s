.include "linux.s"
.include "record_def.s"

# PURPOSE:
#   writes a record to the file descriptor.
#
# INPUT:
#   file descriptor
#   buffer
#
# OUTPUT:
#   returns a status code.

.equ ST_WRITE_BUFFER, 16
.equ ST_FILE_DESCRIPTOR, 24

.globl write_record

.type write_record, @function

write_record:
    push %rbp
    mov %rsp, %rbp

    mov $SYS_WRITE, %rax
    mov ST_FILE_DESCRIPTOR(%rbp), %rdi
    mov ST_WRITE_BUFFER(%rbp), %rsi
    mov $RECORD_SIZE, %rdx
    syscall

    mov %rbp, %rsp
    pop %rbp
    ret
