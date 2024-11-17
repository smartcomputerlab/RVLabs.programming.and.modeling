    .data
vector1: .word 10, 20, 30, 40, 50, 60, 70, 80      # First vector with 8 elements
vector2: .word 5, 15, 25, 35, 45, 55, 65, 75       # Second vector with 8 elements
result:  .space 32                                 # Space for 8 results (each result is 4 bytes)
output:  .space 256                                # Buffer for ASCII output of all elements

    .text
    .globl _start

# itoa: Convert integer in a0 to ASCII string
# Input: Integer value in a0, buffer address in a1
# Output: ASCII string in buffer

itoa:
    mv t1, t6                     # t1 will be our working buffer pointer
    li t2, 10                     # Base 10 for conversion

itoa_loop:
    rem t3, a0, t2                # t3 = a0 % 10 (last digit)
    addi t3, t3, 48               # Convert to ASCII ('0' = 48)
    sb t3, 0(t1)                  # Store ASCII character in buffer
    addi t1, t1, 1                # Move to the next buffer position

    div a0, a0, t2                # a0 = a0 / 10
    bnez a0, itoa_loop            # Repeat until a0 == 0

    # Reverse the string
    addi t1, t1, -1               # Move t1 back to the last written character
    mv t3, a1                     # t3 points to start of the string
itoa_reverse:
    bge t3, t1, itoa_done         # If t3 >= t1, we're done
    lb t4, 0(t3)                  # Load byte from start
    lb t5, 0(t1)                  # Load byte from end
    sb t5, 0(t3)                  # Swap start byte with end byte
    sb t4, 0(t1)                  # Swap end byte with start byte
    addi t3, t3, 1                # Move start forward
    addi t1, t1, -1               # Move end backward
    j itoa_reverse

itoa_done:
    sb zero, 0(t1)                # Null-terminate the string
    jr ra                         # Return


# Main program
_start:
    # Load vector addresses into registers
    la t0, vector1                # Load address of vector1 into t0
    la t1, vector2                # Load address of vector2 into t1
    la t2, result                 # Load address of result into t2

    # Set up vector configuration
    li t3, 8                      # Vector length (8 elements)
    vsetvli t4, t3, e32           # Set vector length to 8 with 32-bit elements

    # Load vectors
    vle32.v v0, 0(t0)                # Load vector1 into v0
    vle32.v v1, 0(t1)                # Load vector2 into v1

    # Perform vector addition
    vadd.vv v2, v0, v1            # Add v0 and v1, store result in v2

    # Store result vector back to memory
    vse32.v v2, 0(t2)                # Store v2 into result array

    # Convert each result element to ASCII and print
    la t5, result                 # Load address of result array
    la t6, output                 # Load address of output buffer

    li t4, 8                      # Loop counter for 8 elements
vector_output_loop:
    lw a0, 0(t5)                  # Load the next element of the result into a0
    jal ra, itoa                  # Call itoa to convert integer in a0 to ASCII

    # Print ASCII result
    li a7, 64                     # Syscall number for write (Linux)
    li a0, 1                      # File descriptor 1 (stdout)
    mv a1, t6                     # Address of ASCII output buffer
    li a2, 32                     # Max characters to write (adjust if necessary)
    ecall                         # Output the ASCII result to stdout

    addi t5, t5, 4                # Move to the next result element (4 bytes)
    addi t4, t4, -1               # Decrement counter
    bnez t4, vector_output_loop   # Repeat for all 8 elements

    # Exit program
    li a7, 93                     # Syscall number for exit
    ecall                         # Exit program

