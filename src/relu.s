.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    
    li t0 1
    blt a1, t0, invalid 
    
    mv t0, a0
    mv t1, a1
    li t3, 0 # i
    li t4, 0 # t4 = i * 4 + t0
    
loop:
    slli t4, t3, 2
    add t4, t4, t0

    lw t6, 0(t4) # t6 = array[i]
    bge t6, x0, positive
    li t6, 0
    sw t6, 0(t4)
    
positive:
    addi t3, t3, 1
    blt t3, t1, loop
       
    lw ra, 12(sp)
    addi sp, sp, 16
    jr ra
    
invalid:
    li a0 36
    lw ra, 12(sp)
    addi sp, sp, 16
    j exit

    