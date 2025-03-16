.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    bne a0, t0, invalid_arg_count

    addi sp, sp, -128
    sw ra, 24(sp)       # first 24 bytes are for reading 3 matrices
    sw s0, 28(sp)
    sw s1, 32(sp)
    sw s2, 36(sp)
    sw s3, 40(sp)
    sw s4, 44(sp)
    sw s5, 48(sp)
    sw s6, 52(sp)
    sw s7, 56(sp)
    sw s8, 60(sp)
    sw s9, 64(sp)
    sw s10, 68(sp)
    sw s11, 72(sp)
    
    mv s0, a0           # argc
    mv s1, a1           # argv (char**)
    mv s2, a2           # print mode
    
    # Read pretrained m0
    lw a0, 4(s1)     # a1[1]
    mv a1, sp           # a1 = sp
    addi a2, a1, 4      # a2 = sp + 4
    jal read_matrix
    mv s3, a0           # s3 has the pointer to the m0 matrix in memory
    
    # Read pretrained m1
    lw a0, 8(s1)     # a1[2]
    addi a1, sp, 8      # a1 = sp + 8
    addi a2, a1, 4      # a2 = sp + 12
    jal read_matrix
    mv s4, a0           # s4 has the pointer to the m1 matrix in memory

    # Read input matrix
    lw a0, 12(s1)     # a1[3]
    addi a1, sp, 16     # a1 = sp + 16
    addi a2, a1, 4      # a2 = sp + 20
    jal read_matrix
    mv s5, a0           # s5 has the pointer to the input matrix in memory

    # Compute h = matmul(m0, input)
    lw t0, 0(sp)    # t0 = m0_row
    lw t1, 20(sp)   # t1 = input_col
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_fail
    mv s6, a0       # s6 has the pointer to the h matrix in memory
    
    mv a0, s3       # a0 = &m0 
    lw a1, 0(sp)    # a1 = m0_row
    lw a2, 4(sp)    # a2 = m0_col
    mv a3, s5       # a3 = &input
    lw a4, 16(sp)   # a4 = input_row
    lw a5, 20(sp)   # a5 = input_col
    mv a6, s6       # a6 = &h
    mv s7, a1       # s7 = h_row
    mv s8, a5       # s8 = h_col
    mul s9, a1, a5  # s9 = m0_row x input_col (h total element)
    jal matmul
    
    # Compute h = relu(h)
    mv a0, s6       # a0 = &h
    mv a1, s9       # a1 = len(h)
    jal relu

    # Compute o = matmul(m1, h)
    lw t0, 8(sp)    # m1_row
    mul a0, t0, s8  # a0 = m1_row x h_col
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_fail
    mv s10, a0       # s10 has the pointer to the o matrix in memory
    
    mv a0, s4       # a0 = &m1
    lw a1, 8(sp)    # a1 = m1_row
    lw a2, 12(sp)   # a2 = m1_col
    mv a3, s6       # a3 = &h
    mv a4, s7       # a4 = h_row
    mv a5, s8       # a5 = h_col
    mv a6, s10      # a6 = &o
    mv t0, a1
    mv t1, a5
    
    sw t0, 76(sp)   # o_row
    sw t1, 80(sp)   # o_col
    
    jal matmul
    
    lw t0, 76(sp)   # o_row
    lw t1, 80(sp)   # o_col

    # Write output matrix o
    lw a0, 16(s1) # a1[4]
    mv a1, s10
    mv a2, t0
    mv a3, t1
    jal write_matrix

    # Compute and return argmax(o)
    lw t0, 76(sp)   # o_row
    lw t1, 80(sp)   # o_col
    
    mv a0, s10
    mul a1, t0, t1
    jal argmax
    mv s11, a0

    # If enabled, print argmax(o) and newline
    li t0, 1
    beq s2, t0, silent_mode
    jal print_int
    li a0, '\n'
    jal print_char
    
silent_mode:
    
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s10
    jal free
    
    mv a0, s11
    
    lw ra, 24(sp)       # first 24 bytes are for reading 3 matrices
    lw s0, 28(sp)
    lw s1, 32(sp)
    lw s2, 36(sp)
    lw s3, 40(sp)
    lw s4, 44(sp)
    lw s5, 48(sp)
    lw s6, 52(sp)
    lw s7, 56(sp)
    lw s8, 60(sp)
    lw s9, 64(sp)
    lw s10, 68(sp)
    lw s11, 72(sp)
    
    addi sp, sp, 128
    
    jr ra
    
malloc_fail:
    li a0, 26
    j exit
    
invalid_arg_count:
    li a0, 31
    j exit