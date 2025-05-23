    .text
    .globl u_mult

# Function: multiply_unsigned
# Description:
#   Multiplies two unsigned integers using only add and shift instructions.
# Arguments:
#   a0: The first unsigned integer (multiplicand)
#   a1: The second unsigned integer (multiplier)
# Returns:
#   a0: The product of the two unsigned integers

u_mult:
    li t0, 0                 # Initialize result to 0 (stored in t0)
    li t1, 1                 # Mask to test each bit of the multiplier
loop:
    and t2, a1, t1           # Check if the current bit of the multiplier is set
    beq t2, zero, skip_add   # If the bit is not set, skip the addition

    add t0, t0, a0           # Add the multiplicand to the result
skip_add:
    sll a0, a0, 1            # Shift the multiplicand left by 1 (equivalent to multiplying by 2)
    srl a1, a1, 1            # Shift the multiplier right by 1 to process the next bit
    bnez a1, loop            # If the multiplier is not zero, continue the loop
    mv a0, t0                # Move the result from t0 to a0 (return value)
    ret                      # Return to caller
