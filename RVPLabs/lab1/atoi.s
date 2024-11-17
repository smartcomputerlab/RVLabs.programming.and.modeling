    .data
buffer:       .space 32            # Buffer to store input string (up to 31 chars + null terminator)

    .text
    .global atoi

atoi:
    # Read input from stdin into buffer
    la a1, buffer                  # Load address of buffer into a0
    li a7, 63                       # Syscall number for read (Linux RISC-V read syscall is 63)
    li a0, 0                        # File descriptor for stdin (0)
    li a2, 32                       # Max length of input
    ecall                           # Make syscall to read input

    # Convert ASCII string to integer and store result in a2
    la t0, buffer                   # Load the address of the input buffer
    li a2, 0                        # Initialize a2 to hold the result integer (0)

atoi_loop:
    lb t1, 0(t0)                    # Load the next character from buffer
    li t4, 10
    beq t1, t4, end_atoi             # If character is new line terminator, end conversion
    #beq t1, zero, end_atoi          # If character is null terminator, end conversion

    # Convert ASCII '0'-'9' to integer value
    li t2, '0'                      # ASCII value for '0'
    sub t1, t1, t2                  # t1 now holds the integer value of the ASCII character

    # Accumulate the result in a2
    li t3, 10                       # Load constant 10 to multiply by base 10
    mul a2, a2, t3                  # Multiply current result by 10
    add a2, a2, t1                  # Add the integer value of the current digit to result

    # Move to the next character in the buffer
    addi t0, t0, 1                  # Increment pointer to next character
    j atoi_loop                     # Repeat the loop

end_atoi:
    mv  a0, a2
    ret


