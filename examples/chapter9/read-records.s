.include "linux.s"
.include "record-def.s"

# PURPOSE:
#   print on the terminal the names of the records in a file.

.equ ST_SIZE_RESERVE, 16
.equ ST_INPUT_DESCRIPTOR, -8
.equ ST_OUTPUT_DESCRIPTOR, -16

.section .data

filename:
    .ascii "test.dat\0"

record_buffer_ptr:
    .quad 0

.section .text

.globl _start

_start:
    mov %rsp, %rbp
    sub $ST_SIZE_RESERVE, %rsp

    call allocate_init

    mov $SYS_OPEN, %rax
    mov $filename, %rdi
    mov $O_RDONLY, %rsi
    mov $PERMISSION, %rdx
    syscall

    mov %rax, ST_INPUT_DESCRIPTOR(%rbp)
    movq $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)

record_read_loop:
    # Allocate memory for a record.
    push $RECORD_SIZE
    call allocate
    add $8, %rsp

    mov %rax, record_buffer_ptr

    # Read a record.
    push ST_INPUT_DESCRIPTOR(%rbp)
    push record_buffer_ptr
    call read_record
    add $16, %rsp

    cmp $RECORD_SIZE, %rax
    jne end_read

    # Get the length of the record name.
    mov record_buffer_ptr, %rax
    add $RECORD_LASTNAME, %rax
    push %rax
    call count_chars
    add $8, %rsp

    # Print record name on the terminal.
    mov %rax, %rdx  # length as the buffer size
    mov $SYS_WRITE, %rax
    mov ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
    mov record_buffer_ptr, %rsi
    add $RECORD_LASTNAME, %rsi
    syscall

    # Print newline on the terminal.
    push ST_OUTPUT_DESCRIPTOR(%rbp)
    call write_newline
    add $8, %rsp

    push record_buffer_ptr
    call deallocate
    add $8, %rsp
    
    jmp record_read_loop

end_read:
    # Free the allocated memory.
    push record_buffer_ptr
    call deallocate
    add $8, %rsp

    mov $SYS_EXIT, %rax
    mov $0, %rdi
    syscall
