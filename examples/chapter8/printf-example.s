# PURPOSE:
#   call printf.

.section .data

first_string:
    .ascii "Hello! %s is a %s who loves the number %d\n\0"

name:
    .ascii "Jonathan\0"

personstring:
    .ascii "person\0"

numberloved:
    .quad 3

.section .text

.globl _start

_start:
    # Push in reverse order.
    push numberloved
    push $personstring
    push $name
    push $first_string
    call printf

    push $0
    call exit
