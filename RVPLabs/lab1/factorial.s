    .text
    .globl factorial

# Function: factorial
# Description:
#   Computes the factorial of a given unsigned integer n using an iterative method.
# Arguments:
#   a0: The input number n
# Returns:
#   a0: The result of n!

factorial:
    li t0, 1                # Initialize result to 1 (t0 will hold the factorial value)
    # Check if n is zero or one (0! and 1! are both 1)
    beq a0, t1, factorial_end # If a0 (n) <= 1, skip to the end (result is 1)
factorial_loop:
    mul t0, t0, a0          # t0 = t0 * a0 (multiply the current result by n)
    addi a0, a0, -1         # a0 = a0 - 1 (decrement n by 1)
    bnez a0, factorial_loop # If a0 != 0, continue looping
factorial_end:
    mv a0, t0               # Move the final result to a0 (return value)
    ret                     # Return to caller

