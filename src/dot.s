.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

######################## ERROR CHECKS ########################
    addi t0, x0, 1
    blt a2, t0, invalid_element_num

    blt a3, t0, invalid_stride
    blt a4, t0, invalid_stride
######################## ERROR CHECKS ########################

    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)

    mv s0, a0
    mv s1, a1
    li t0, 0        # total sum
    li t1, 0        # i

loop:
    bge t1, a2, loop_end

    mul t2, t1, a3  # t2 = i * a1_stride
    slli t2, t2, 2  # t2 = t2 * 4
    mul t3, t1, a4  # t3 = i * a2_stride
    slli t3, t3, 2  # t3 = t3 * 4

    add t2, t2, s0
    lw t2, 0(t2)
    add t3, t3, s1
    lw t3, 0(t3)

    mul t4, t2, t3
    add t0, t0, t4

    addi t1, t1, 1
    j loop

loop_end:
    mv a0, t0

    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    jr ra

######################## ERROR CHECKS ########################
invalid_element_num:
    li a0, 36
    j exit

invalid_stride:
    li a0, 37
    j exit
######################## ERROR CHECKS ########################
