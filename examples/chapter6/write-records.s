.include "linux.s"
.include "record-def.s"

# PURPOSE:
#   write three person's records to a file.

.equ ST_SIZE_RESERVE, 8
.equ ST_FILE_DESCRIPTOR, -8

.section .data

record1:
    # firstname
    .ascii "Fredrick\0"
    .rept 31   # padding to 40 bytes
    .byte 0
    .endr

    # lastname
    .ascii "Bartlett\0"
    .rept 31   # padding to 40 bytes
    .byte 0
    .endr

    # address
    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209  # padding to 240 bytes
    .byte 0
    .endr

    # age
    .quad 45

record2:
    # firstname
    .ascii "Marilyn\0"
    .rept 32   # padding to 40 bytes
    .byte 0
    .endr

    # lastname
    .ascii "Taylor\0"
    .rept 33   # padding to 40 bytes
    .byte 0
    .endr

    # address
    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203  # padding to 240 bytes
    .byte 0
    .endr

    # age
    .quad 29

record3:
    # firstname
    .ascii "Derrick\0"
    .rept 32   # padding to 40 bytes
    .byte 0
    .endr

    # lastname
    .ascii "McIntire\0"
    .rept 31   # padding to 40 bytes
    .byte 0
    .endr

    # address
    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206  # padding to 240 bytes
    .byte 0
    .endr

    # age
    .quad 36

filename:
    .ascii "test.dat\0"

.section .text

.globl _start

_start:
    mov %rsp, %rbp
    sub $ST_SIZE_RESERVE, %rsp

    mov $SYS_OPEN, %rax
    mov $filename, %rdi
    mov $O_CREAT_WRONLY, %rsi
    mov $PERMISSION, %rdx
    syscall

    mov %rax, ST_FILE_DESCRIPTOR(%rbp)

    # Write first record.
    push ST_FILE_DESCRIPTOR(%rbp)
    push $record1
    call write_record
    add $16, %rsp

    # Write second record.
    push ST_FILE_DESCRIPTOR(%rbp)
    push $record2
    call write_record
    add $16, %rsp

    # Write third record.
    push ST_FILE_DESCRIPTOR(%rbp)
    push $record3
    call write_record
    add $16, %rsp

    mov $SYS_CLOSE, %rax
    mov ST_FILE_DESCRIPTOR(%rbp), %rdi
    syscall

    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
