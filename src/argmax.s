.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    addi t0, x0, 1
    beq a1, t0, len_1
    blt a1, t0, invalid
    
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    
    mv s0, a0
    
    li t2, 0            # i
    li t6, 0x80000000   # current max -2^31

loop:
    bge t2, a1, loop_end 

    slli t4, t2, 2      # t4 = i * 4
    add t4, t4, s0      # t4 += s0 (a0)
    lw t4, 0(t4)        # a[i]
    
    bgt t4, t6, update  # if a[i] > current_max branch to update
    addi t2, t2, 1
    j loop
update:
    mv a0, t2           # update return index
    mv t6, t4           # set current max to a[i]
    addi t2, t2, 1
    j loop
    
loop_end:
    
    lw s0, 8(sp)
    lw ra, 12(sp)

    addi sp, sp, 16
    jr ra
    
len_1:
    mv a0 x0
    jr ra
    
invalid:
    li a0, 36
    j exit