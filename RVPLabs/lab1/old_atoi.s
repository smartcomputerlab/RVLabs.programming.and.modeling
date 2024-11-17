    .data
buffer:
    .space 64           # Reserve 64 bytes of space for reading the input

    .text
    .globl atoi

# Function atoi: reads an ASCII unsigned integer from stdin and converts it to an integer stored in a0
atoi:
    la a1, buffer       # Load address of the buffer
    li a2, 64           # Set the maximum number of bytes to read
    li a7, 63           # System call number for read (Linux/RISC-V)
    li a0, 0            # File descriptor 0 (stdin)
    ecall               # Make the system call to read from stdin

    # Prepare for conversion
    la a1, buffer       # Reset pointer to the start of the buffer
    li a0, 0            # Initialize the integer result in a0

convert_loop:
    lbu t0, 0(a1)       # Load the current character
    li t2, 10           # ASCII code for newline ('\n')
    beq t0, t2, end_atoi # If newline, finish conversion

    li t3, 48           # ASCII code for '0'
    li t4, 57           # ASCII code for '9'
    blt t0, t3, end_atoi  # If t0 < '0', end conversion (non-numeric)
    bgt t0, t4, end_atoi  # If t0 > '9', end conversion (non-numeric)

    sub t0, t0, t3      # Convert ASCII character to its integer value
    li  t5, 10
    mul a0, a0, t5      # Multiply current result by 10
    add a0, a0, t0      # Add the integer value to a0
    addi a1, a1, 1      # Move to the next character
    j convert_loop      # Repeat the loop

end_atoi:
    ret                 # Return with the result in a0

