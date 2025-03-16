.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4-byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
#
# Arguments:
#   a0 (char*) is a pointer to the string representing the filename
#   a1 (int*)  is a pointer to an integer, to store the number of rows
#   a2 (int*)  is a pointer to an integer, to store the number of columns
#
# Returns:
#   a0 (int*)  is a pointer to the matrix data in memory (row-major order).
#
# Exceptions:
#   - If malloc returns 0,   exit with code 26
#   - If fopen fails,        exit with code 27
#   - If fread fails,        exit with code 29
#   - If fclose fails,       exit with code 28
# ==============================================================================

read_matrix:
    # Save registers on the stack
    addi    sp, sp, -64
    sw      s0, 60(sp)
    sw      s1, 56(sp)
    sw      s2, 52(sp)
    sw      s3, 48(sp)
    sw      s4, 44(sp)
    sw      s5, 40(sp)
    sw      s6, 36(sp)
    sw      s7, 32(sp)
    sw      ra, 28(sp)

    # Save pointers for row/col counts into s1 and s2
    mv      s1, a1            # pointer for row count
    mv      s2, a2            # pointer for col count

    li      a1, 0             # read-only mode
    jal     fopen
    addi    t0, x0, -1
    beq     a0, t0, fopen_error
    mv      s3, a0            # s3 = file descriptor

    mv      a0, s3            # file descriptor
    mv      a1, s1            # destination buffer (the int* for rows)
    li      a2, 4             # number of bytes
    jal     fread
    li      t0, 4
    bne     a0, t0, fread_error
    lw      s4, 0(s1)         # s4 = row count

    mv      a0, s3            # file descriptor
    mv      a1, s2            # destination buffer (the int* for cols)
    li      a2, 4             # number of bytes
    jal     fread
    li      t0, 4
    bne     a0, t0, fread_error
    lw      s5, 0(s2)         # s5 = column count

    mul     a0, s4, s5        # total elements
    slli    a0, a0, 2         # each element is 4 bytes
    jal     malloc
    beq     a0, x0, malloc_error
    mv      s6, a0            # s6 = pointer to newly allocated block

    mul     s0, s4, s5        # total elements
    slli    s0, s0, 2         # total bytes = row * col * 4

    mv      a0, s3            # file descriptor
    mv      a1, s6            # destination pointer
    mv      a2, s0            # total bytes
    jal     fread
    bne     a0, s0, fread_error

    mv      a0, s3
    jal     fclose
    bne     a0, x0, fclose_error

    # Return the pointer to the matrix in a0
    mv      a0, s6

    # Restore saved registers
    lw      s0, 60(sp)
    lw      s1, 56(sp)
    lw      s2, 52(sp)
    lw      s3, 48(sp)
    lw      s4, 44(sp)
    lw      s5, 40(sp)
    lw      s6, 36(sp)
    lw      s7, 32(sp)
    lw      ra, 28(sp)
    addi    sp, sp, 64
    jr      ra

# ==============================================================================
# Error-handling code for different failure modes
# ==============================================================================
fopen_error:
    li      a0, 27  # exit code for fopen error
    j       exit

malloc_error:
    li      a0, 26  # exit code for malloc error
    j       exit

fread_error:
    li      a0, 29  # exit code for fread error
    j       exit

fclose_error:
    li      a0, 28  # exit code for fclose error
    j       exit
