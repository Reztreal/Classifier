.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

######################## ERROR CHECKS ########################
    li t0, 1
    blt a1, t0, invalid_size
    blt a2, t0, invalid_size
    blt a4, t0, invalid_size
    blt a5, t0, invalid_size

    bne a2, a4, invalid_mul
######################## ERROR CHECKS ########################

    addi sp, sp, -64
    sw ra, 60(sp)
    sw s0, 56(sp)
    sw s1, 52(sp)
    sw s2, 48(sp)
    sw s3, 44(sp)
    sw s4, 40(sp)
    sw s5, 36(sp)
    sw s6, 32(sp)

    li t0, 0        # i
    li t1, 0        # j

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

outer_loop_start:
    bge t0, s1, outer_loop_end

    slli t2, t0, 2  # i * 4
    mul t2, t2, s2  # (i * 4) * (A col number)
    add t2, t2, s0  # &A + (i * 4) * (A col number)

inner_loop_start:
    bge t1, s5, inner_loop_end

    li t3, 4
    mul t3, t3, t1
    add t3, t3, s3 # start of jth col of B

    mv a0, t2
    mv a1, t3
    mv a2, s2
    li a3, 1
    mv a4, s5

    sw t0, 28(sp)
    sw t1, 24(sp)
    sw t2, 20(sp)
    sw t3, 16(sp)

    jal dot

    lw t3, 16(sp)
    lw t2, 20(sp)
    lw t1, 24(sp)
    lw t0, 28(sp)

    mul t4, s5, t0  # (B col num) * i + j since row major order
    add t4, t4, t1  
    slli t4, t4, 2
    add t4, t4, s6  # C[index]

    sw a0, 0(t4)    # C[index] = dot(A_r_i, B_col_j)

    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    li t1, 0
    j outer_loop_start

outer_loop_end:

    lw ra, 60(sp)
    lw s0, 56(sp)
    lw s1, 52(sp)
    lw s2, 48(sp)
    lw s3, 44(sp)
    lw s4, 40(sp)
    lw s5, 36(sp)
    lw s6, 32(sp)

    addi sp, sp, 64

    jr ra

######################## ERROR CHECKS ########################
invalid_size:
    li a0, 38
    j exit

invalid_mul:
    li a0, 38
    j exit
######################## ERROR CHECKS ########################