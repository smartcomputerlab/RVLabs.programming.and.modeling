    .section .rodata
vector:
    .word 123, 456, 789, 1011, 1213, 1415, 1617, 1819  # Example integer values in vector

    .section .data
ascii_output:
    .space 80  # Space to store the ASCII output for 8 integers (10 chars per integer max)

    .section .text
    .globl _start
_start:
    la t0, vector              # Load the address of the integer vector
    la t1, ascii_output        # Load the address of the ASCII output buffer
    li t2, 8                   # Number of elements in the vector

convert_loop:
    # Load each integer from the vector
    lw a0, 0(t0)               # Load the next integer into a0
    addi t0, t0, 4             # Move to the next integer in the vector

    # Convert the integer to ASCII and store in ascii_output buffer
    mv a1, t1                  # Pass the current buffer position to itoa
    jal itoa                   # Call itoa function

    # Move to the next output position (10 chars per integer)
    addi t1, t1, 10

    # Decrement counter and loop if not done
    addi t2, t2, -1
    bnez t2, convert_loop

    # Print ASCII output
    la a1, ascii_output        # Address of the ASCII output buffer
    li a0, 1                   # File descriptor for stdout
    li a2, 80                  # Length of ASCII output (8 elements * 10 chars max each)
    li a7, 64                  # Syscall number for write
    ecall                      # Make syscall to write

    # Exit program
    li a7, 93                  # Syscall number for exit
    li a0, 0                   # Exit code 0
    ecall

# itoa function to convert integer in a0 to ASCII string in a1
# Assumes a 10-character buffer is available at a1
itoa:
    addi sp, sp, -16           # Allocate stack space
    sw a0, 0(sp)               # Save original integer on stack
    addi t0, zero, 10          # Base 10
    addi t1, a1, 9             # Start filling from the end of buffer
    sb zero, 10(a1)            # Null-terminate the string

itoa_loop:
    # Get the last digit by dividing by 10
    divu a2, a0, t0            # a2 = a0 / 10 (quotient)
    remu a3, a0, t0            # a3 = a0 % 10 (remainder)
    addi a3, a3, 48            # Convert remainder to ASCII ('0' = 48)
    sb a3, 0(t1)               # Store ASCII character in buffer
    addi t1, t1, -1            # Move to next position in buffer
    mv a0, a2                  # Update a0 with the quotient
    bnez a0, itoa_loop         # Repeat if quotient is not zero

    addi t1, t1, 1             # Move t1 to start of number string
    add a1, a1, t1             # Adjust a1 to point to start of string
    lw a0, 0(sp)               # Restore original integer (optional)
    addi sp, sp, 16            # Restore stack
    jr ra                      # Return to caller

