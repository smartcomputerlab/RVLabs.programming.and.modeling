.section   .rodata
   .balign 4
	vector2:  .word 1, 2, 3, 4, 5, 6, 7, 8          # First 8-word vector
   .balign 4
	vector1:  .word 1, 2, 3, 4, 5, 6, 7, 8          # Second 8-word vector
.section   .data
   .balign 4
	result:   .space 32                            # Space for the result (8 x 4 bytes)

    .text
    .global _start, itoa


# itoa: Convert integer in a0 to ASCII string
# Input: Integer value in a0, buffer address in a1
# Output: ASCII string in buffer
itoa:
    la  t1, result    
#mv t1, a1                    # t1 will be our working buffer pointer
    li t2, 10                    # Base 10 for conversion

itoa_loop:
    rem t3, a0, t2               # t3 = a0 % 10 (last digit)
    addi t3, t3, 48              # Convert to ASCII ('0' = 48)
    sb t3, 0(t1)                 # Store ASCII character in buffer
    addi t1, t1, 1               # Move to the next buffer position

    div a0, a0, t2               # a0 = a0 / 10
    bnez a0, itoa_loop           # Repeat until a0 == 0
    sb  zero, 0(t1)              # add ascii 0

    # Reverse the string
    addi t1, t1, -1              # Move t1 back to the last written character
    la t3, result                # t3 points to start of the string

itoa_reverse:
    bge t3, t1, itoa_done        # If t3 >= t1, we're done
    lb t4, 0(t3)                 # Load byte from start
    lb t5, 0(t1)                 # Load byte from end
    sb t5, 0(t3)                 # Swap start byte with end byte
    sb t4, 0(t1)                 # Swap end byte with start byte
    addi t3, t3, 1               # Move start forward
    addi t1, t1, -1              # Move end backward
    j itoa_reverse

itoa_done:
    jr ra                        # Return

_start:
    # Set up vector length register(VLEN = 8 elements, each 32 bits)
    li t0, 8                      # vector length is 8
    vsetvli t0,t0,e32,m1          # vector length for 32-bit elements, one operation per element
    # Load the vectors into vector registers
    la t1, vector1                   # Load address of vector1 into t1
    vle32.v v0,0(t1)                   # Load 8-word vector1 into vector register v0
    la t2, vector2                   # Load address of vector2 into t2
    vle32.v v1,0(t2)                   # Load 8-word vector2 into vector register v1
    # Perform vector addition
    vadd.vv v2, v0, v1               # v2 = v0 + v1 (element-wise vector addition)
    # Store the result back to memory
    la t3, result                    # Load address of result into t3
    vse32.v v2,0(t3)                   # Store the result from vector register v2 into memory

    jal  ra, itoa

    # Print result string (converted integer) to stdout
    li a7, 64                    # Syscall number for write (Linux)
    li a0, 1                     # File descriptor 1 (stdout)
    la a1, result                # Address of output buffer
    li a2, 32                    # Number of bytes to write
    ecall                        # Output result

    # Exit the program (using system call for exit)
    li a0,0
    li a7, 93                        # System call number for exit in RISC-V (64-bit)
    ecall                            # Exit the program

