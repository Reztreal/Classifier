.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw s0, 56(sp)
    sw s1, 52(sp)
    sw s2, 48(sp)
    sw s3, 44(sp)
    sw s4, 40(sp)
    sw s5, 36(sp)
    sw s6, 32(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s4, a0
    
    mv t0, s2
    sw t0, 0(sp)
    
    mv a0, s4
    mv a1, sp
    li a2, 1
    li a3, 4
    jal fwrite  # write row count to file
    li t0, 1
    bne a0, t0, fwrite_error
    
    mv t0, s3
    sw t0, 0(sp)
    
    mv a0, s4
    mv a1, sp
    li a2, 1
    li a3, 4
    jal fwrite  # write col count to file
    li t0, 1
    bne a0, t0, fwrite_error
    
    li s5, 0    # i
    mul s6, s2, s3
loop_begin:
    beq s5, s6, loop_end

    slli t0, s5, 2  # i * 4
    add t0, t0, s1  # array[i]
    
    mv a0, s4
    mv a1, t0
    li a2, 1
    li a3, 4
    jal fwrite  # write array[i] to file
    li t0, 1
    bne a0, t0, fwrite_error
    
    addi s5, s5, 1
    j loop_begin
loop_end:
    
    mv a0, s4
    jal fclose
    li t0, -1
    beq a0, t0, fclose_error
    
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
    
fopen_error:
    li a0, 27
    j exit
    
fwrite_error:
    li a0, 30
    j exit  
    
fclose_error:
    li a0, 28
    j exit      
    
    
    
    
    