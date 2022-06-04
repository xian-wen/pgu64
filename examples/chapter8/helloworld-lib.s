# PURPOSE:
#   prints "hello world" (use lib version).
#
# (Ref: https://stackoverflow.com/questions/30419857/accessing-a-corrupted-shared-library)
# Assemble:
# as --32 -g helloworld-lib.s -o helloworld-lib.o
# Link:
# ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc helloworld-lib.o -o helloworld-lib
# Run:
# ./helloworld

.section .data

helloworld:
    .ascii "hello world\n\0"

.section .text

.globl _start

_start:
    push $helloworld
    call printf

    push $0
    call exit
