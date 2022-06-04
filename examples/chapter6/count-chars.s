# PURPOSE:
#   count the length of the null-terminated character string.
#
# INPUT:
#   the address of the charater string.
#
# OUTPUT:
#   the length of the character string.
#
# VARIABLES:
#   %rax - current length
#   %rdi - current character address
#   %sil - current character

.equ ST_STRING_START_ADDRESS, 16

.globl count_chars

.type count_chars, @function

count_chars:
    push %rbp
    mov %rsp, %rbp

    mov $0, %rax
    mov ST_STRING_START_ADDRESS(%rbp), %rdi

count_loop_begin:
    mov (%rdi), %sil
    cmp $0, %sil
    je end_count

    inc %rax
    inc %rdi
    jmp count_loop_begin

end_count:
    mov %rbp, %rsp
    pop %rbp
    ret
