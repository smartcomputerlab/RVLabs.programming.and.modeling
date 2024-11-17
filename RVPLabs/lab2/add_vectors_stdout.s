.section  .rodata
vecA:  .word 1, 2, 3, 4, 5, 6, 7, 8          # First 8-word vector
vecB:  .word 1, 2, 3, 4, 5, 6, 7, 8          # Second 8-word vector
.section  .data
result:   .space 32                                                   # Space for the result (8 x 4 bytes)
    .align 4
.section  .data
ascii_output: .space 80                            # Space to store the ASCII output of 8 elements (10 chars per element)

    .section .text
    .globl _start
_start:
    # Setup vector registers
    li t0, 8                              # Number of elements in vectors
    li t1, 4                              # Size of each element (4 bytes)
    vsetvli t0, t0, e32, m1               # Set vector length for 8 elements of 32-bit (e32)

    # Load vecA and vecB into vector registers
    la t2, vecA                           # Load address of vecA
    vle32.v v0, (t2)                      # Load vecA into vector register v0

    la t3, vecB                           # Load address of vecB
    vle32.v v1, (t3)                      # Load vecB into vector register v1

    # Perform vector addition: v2 = v0 + v1
    vadd.vv v2, v0, v1                    # Element-wise addition of v0 and v1, store in v2

    # Store result vector to memory
    la t4, result                         # Load address of result array
    vse32.v v2, (t4)                      # Store the result vector from v2 into result array

    # Convert each result to ASCII and print
    la t5, result                         # Load result array address
    la t6, ascii_output                   # Load ascii_output array address

    li t0, 8                              # Number of elements to process

convert_loop:
    # Load the next result element into a register
    lw a0, 0(t5)                          # Load result element into a0
    addi t5, t5, 4                        # Move to next element in result array

    # Call itoa to convert integer to ASCII (decimal) string
    mv a1, t6                             # Address to store ASCII string
    jal itoa                              # Call itoa function

    # Move to the next ASCII output space (10 chars per int)
    addi t6, t6, 10

    # Decrement counter and loop if not done
    addi t0, t0, -1
    bnez t0, convert_loop

    # Print ASCII output
    la a1, ascii_output                   # Address of the ASCII output buffer
    li a0, 1                              # File descriptor for stdout
    li a2, 80                             # Length of ASCII output (8 elements * 10 chars max each)
    li a7, 64                             # Syscall number for write
    ecall                                 # Make syscall to write

    # Exit program
    li a7, 93                             # Syscall number for exit
    li a0, 0                              # Exit code 0
    ecall

# itoa function to convert integer in a0 to ASCII string in a1
# Assumes a 10-character buffer is available at a1
itoa:
    addi sp, sp, -16                      # Allocate stack space
    sw a0, 0(sp)                          # Save original integer on stack
    addi t0, zero, 10                     # Base 10
    addi t1, a1, 9                        # Start filling from the end of buffer
    sb zero, 10(a1)                       # Null-terminate the string

itoa_loop:
    # Get the last digit by dividing by 10
    divu a2, a0, t0                       # a2 = a0 / 10 (quotient)
    remu a3, a0, t0                       # a3 = a0 % 10 (remainder)
    addi a3, a3, 48                       # Convert remainder to ASCII ('0' = 48)
    sb a3, 0(t1)                          # Store ASCII character in buffer
    addi t1, t1, -1                       # Move to next position in buffer
    mv a0, a2                             # Update a0 with the quotient
    bnez a0, itoa_loop                    # Repeat if quotient is not zero

    addi t1, t1, 1                        # Move t1 to start of number string
    add a1, a1, t1                        # Adjust a1 to point to start of string
    lw a0, 0(sp)                          # Restore original integer (optional)
    addi sp, sp, 16                       # Restore stack
    jr ra                                 # Return to caller

