.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
    lw t0, 0(a0)
    bge t0, x0, Exit
    sub t0, x0, t0
    sw t0, 0(a0)
Exit:
    jr ra
