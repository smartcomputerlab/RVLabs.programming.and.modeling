    .data
prompt_a: 
    .asciz "Enter base (a): "   # Prompt for base
prompt_b: 
    .asciz "Enter exponent (b): " # Prompt for exponent
result_msg: 
    .asciz "Result (a^b): %d\n"  # Format string for result
input_format: 
    .asciz "%d"                  # Input format for scanf

    .text
    .globl _start                   # Define global entry point for C runtime

_start:
    # Prompt for base 'a'
    la   a0, prompt_a             # Load address of prompt_a
    call printf                   # Call printf to print the prompt for base­
    # Read base 'a'
    la   a0, input_format          # Load address of input format string ("%d")
    la   a1, base                 # Load address of base variable
    call scanf                    # Call scanf to read base into memory
    # Prompt for exponent 'b'
    la   a0, prompt_b             # Load address of prompt_b
    call printf                   # Call printf to print the prompt for exponent
    # Read exponent 'b'
    la   a0, input_format          # Load address of input format string ("%d")
    la   a1, exponent             # Load address of exponent variable
    call scanf                    # Call scanf to read exponent into memory
    # Load base and exponent into registers
    lw   a0, base                 # Load base value from memory into a0
    lw   a1, exponent             # Load exponent value from memory into a1
    # Call the power function pow(a0, a1)
    jal  ra, power                # Jump to power function
    # Print the result
    mv   a1, a0                   # Move result (in a0) to a1 for printf
    la   a0, result_msg           # Load address of result message
    call printf                   # Call printf to print the result
    # Exit the program
    li   a7, 93                   # Load exit syscall number
    ecall                         # Make the syscall to exit
# Function: power(a, b) -> a^b
# Arguments:
#   a0 = base (a)
#   a1 = exponent (b)
# Result:
#   a0 = result (a^b)
power:
    li   t0, 1                    # Initialize t0 = 1 (result accumulator)

power_loop:
    beqz a1, end_power            # If exponent (b) is 0, exit loop (base case)
    andi t1, a1, 1                # t1 = a1 & 1 (check if b is odd)
    beqz t1, skip_mult            # If b is even, skip multiplication
    mul t0, t0, a0                # If b is odd, result *= base (t0 = t0 * a0)

skip_mult:
    mul a0, a0, a0                # base *= base (a0 = a0 * a0)
    srli a1, a1, 1                # b >>= 1 (right shift exponent by 1)
    j power_loop                  # Repeat the loop

end_power:
    mv a0, t0                     # Move result (t0) back to a0
    ret                           # Return to caller

    .bss
    .align 4
base: 
    .space 4                      # Reserve space for the base
exponent: 
    .space 4                      # Reserve space for the exponent
