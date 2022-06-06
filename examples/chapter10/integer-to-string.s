# PURPOSE:
#   Convert integer to string.
#
# INPUT:
#   buffer
#   integer
#
# OUTPUT:
#   the converted integer stored in the buffer.
#
# VARIABLES:
#   %rax - current value
#   %rbx - buffer
#   %rdi - base 10
#   %rsi - number of processed characters

.equ ST_INTEGER, 16
.equ ST_BUFFER, 24

.globl integer2string

.type integer2string, @function

integer2string:
    push %rbp
    mov %rsp, %rbp

    mov ST_INTEGER(%rbp), %rax
    mov ST_BUFFER(%rbp), %rbx
    mov $10, %rdi
    mov $0, %rsi

conversion_loop:
    # Set %rdx to 0.
    xor %rdx, %rdx
    # %rax = %rax / %rdi, %rdx = %rax mod %rdi
    div %rdi

    # Convert digit to character.
    add $'0', %rdx
    # Put the converted into stack, since it is reversed.
    push %rdx

    inc %rsi

    cmp $0, %rax
    je copy_reversing_loop
    jmp conversion_loop

copy_reversing_loop:
    pop %rdx
    # Copy the least significant byte to buffer.
    mov %dl, (%rbx)

    inc %rbx
    dec %rsi

    cmp $0, %rsi
    je end_copy 
    jmp copy_reversing_loop

end_copy:
    # Add '\0' at the end.
    movb $0, (%rbx)

    mov %rbp, %rsp
    pop %rbp
    ret
