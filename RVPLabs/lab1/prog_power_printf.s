    .data
result_mes:
    .asciz  "Result (a^b): %d\n"    # data section needed for this program

    .text
    .globl _start          # Entry point for the program

# Entry point of the program
.section  .text
_start:
    # Load the base 'a' and exponent 'b' (you can change these for testing)
    li a0, 2               # Load base 'a' = 2 into a0
    li a1, 5               # Load exponent 'b' = 5 into a1
    # Call the power function: pow(a0, a1)
    jal ra, power          # Jump and link to the 'power' function

    mv  a1,a0
    la  a0,result_mes
    call printf

    # End the program (use ecall to exit)
    li   a7, 93            # Load exit system call number (93)
    ecall                  # Make the system call to exit

# Function: power(a, b) -> a^b
# Arguments:
#   a0 = base (a)
#   a1 = exponent (b)
# Result:
#   a0 = result (a^b)
power:
    li t0, 1               # Initialize t0 = 1 (result accumulator)

power_loop:
    beqz a1, end_power     # If exponent b (a1) is 0, exit loop (base case)
    andi t1, a1, 1         # t1 = a1 & 1 (check if b is odd)
    beqz t1, skip_mult     # If b is even, skip multiplication
    mul t0, t0, a0         # If b is odd, result *= base (t0 = t0 * a0)

skip_mult:
    mul a0, a0, a0         # base *= base (a0 = a0 * a0)
    srli a1, a1, 1         # b >>= 1 (right shift exponent by 1)
    j power_loop           # Repeat the loop

end_power:
    mv a0, t0              # Move the result (t0) back to a0
    ret                    # Return to the caller

