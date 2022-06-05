# PURPOSE:
#   manage memory useage, including allocate and deallocate.
#
# Memory region sturcture:
#   ------------------------------------
#   | Available | Size | Actual memory |
#   ------------------------------------
#                      ^
#                      |
#                      Returned pointer

# CONSTANTS:
.equ HEADER_AVAILABLE_OFFSET, 0
.equ HEADER_SIZE_OFFSET, 8
.equ HEADER_SIZE, 16

.equ UNAVAILABLE, 0
.equ AVAILABLE, 1
.equ SYS_BRK, 12

.section .data

heap_begin:
    .quad 0

current_break:
    .quad 0

.section .text


# PURPOSE:
#   set heap_begin and current_break.

.globl allocate_init

.type allocate_init, @function

allocate_init:
    # Get the last valid usable address.
    mov $SYS_BRK, %rax
    mov $0, %rdi
    syscall

    inc %rax
    mov %rax, current_break
    # The first time needs request memory from Linux.
    mov %rax, heap_begin
    ret


# PURPOSE:
#   find the first big enough and available memory region
#   from the free memory list. If not found, call SYS_BRK 
#   to request a new one.  
# 
# INPUT:
#   size
# 
# OUTPUT:
#   the address of the allocated memory.
#
# VARIABLES:
#   %rax - current memory region
#   %rdi - current break position
#   %rsi - request size
#   %rdx - current size

.equ ST_MEMORY_SIZE, 16

.globl allocate

.type allocate, @function

allocate:
    push %rbp
    mov %rsp, %rbp

    mov ST_MEMORY_SIZE(%rbp), %rsi
    mov heap_begin, %rax
    mov current_break, %rdi

alloc_loop_begin:
    cmp %rdi, %rax
    je move_break

    # Get current size before compare, since next_location 
    # also needs it.
    mov HEADER_SIZE_OFFSET(%rax), %rdx

    cmp $UNAVAILABLE, HEADER_AVAILABLE_OFFSET(%rax)
    je next_location

    cmp %rdx, %rsi
    jle allocate_here  # if %rsi <= %rdx

next_location:
    add $HEADER_SIZE, %rax
    add %rdx, %rax
    jmp alloc_loop_begin

allocate_here:
    movq $UNAVAILABLE, HEADER_AVAILABLE_OFFSET(%rax)
    add $HEADER_SIZE, %rax

    mov %rbp, %rsp
    pop %rbp
    ret

move_break:
    add $HEADER_SIZE, %rdi
    add %rsi, %rdi

    push %rax
    push %rdi
    push %rsi
    
    # The only parameter brk is in %rdi.
    mov $SYS_BRK, %rax
    syscall

    cmp $0, %rax
    je error

    pop %rsi
    pop %rdi
    pop %rax

    # Set allocated memory region.
    movq $UNAVAILABLE, HEADER_AVAILABLE_OFFSET(%rax)
    mov %rsi, HEADER_SIZE_OFFSET(%rax)
    add $HEADER_SIZE, %rax  # return address

    # Set current break.
    mov %rdi, current_break

    mov %rbp, %rsp
    pop %rbp
    ret

error:
    mov $0, %rax  # return 0 when error

    mov %rbp, %rsp
    pop %rbp
    ret


# PURPOSE:
#   free the allocated memory.
#
# Input:
#   the address of the memory.

.equ ST_MEMORY_ADDRESS, 16

.globl deallocate

.type deallocate, @function

deallocate:
    push %rbp
    mov %rsp, %rbp

    mov ST_MEMORY_ADDRESS(%rbp), %rax
    
    # Make %rax point to the memory header.
    sub $HEADER_SIZE, %rax
    movq $AVAILABLE, HEADER_AVAILABLE_OFFSET(%rax)

    mov %rbp, %rsp
    pop %rbp
    ret
