    .text
    .globl power_sq

# Function: power
# Description:
#   Computes the value a^b using exponentiation by squaring and the mul instruction.
# Arguments:
#   a0: The base (a)
#   a1: The exponent (b)
# Returns:
#   a0: The result of a^b

power_sq:
    li t0, 1                # Initialize result to 1 (t0 will hold the final result)
    # Check if the exponent is zero
    beq a1, zero, power_end # If exponent is 0, skip to the end (result is 1)
power_loop:
    andi t1, a1, 1          # Check if the current exponent is odd (t1 = a1 & 1)
    beq t1, zero, skip_mul  # If t1 is 0, skip multiplication (even exponent)
    # If exponent is odd, multiply result by base
    mul t0, t0, a0          # t0 = t0 * a0
skip_mul:
    mul a0, a0, a0          # Square the base: a0 = a0 * a0
    srl a1, a1, 1           # Divide the exponent by 2: a1 = a1 >> 1
    bnez a1, power_loop     # If exponent is not zero, continue the loop
power_end:
    mv a0, t0               # Move the final result
    ret


