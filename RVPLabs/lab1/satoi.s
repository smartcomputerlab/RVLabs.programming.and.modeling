    .data
buffer:
    .space 64           # Reserve 64 bytes of space for reading the input

    .text
    .globl atoi

# Function atoi: reads an ASCII integer from stdin and converts it to an integer stored in a0
atoi:
    la a1, buffer       # Load address of the buffer
    li a2, 64           # Set the maximum number of bytes to read
    li a7, 63           # System call number for read (Linux/RISC-V)
    li a0, 0            # File descriptor 0 (stdin)
    ecall               # Make the system call to read from stdin

    # Prepare for conversion
    la a1, buffer       # Reset pointer to the start of the buffer
    li a0, 0            # Initialize the integer result in a0
    li t1, 0            # Sign flag (0 = positive, 1 = negative)

check_sign:
    lbu t0, 0(a1)       # Load the first character from the buffer
    beqz t0, end_atoi   # If the character is null (end of string), end the function
    li t2, 45           # ASCII code for '-'
    beq t0, t2, set_negative # If the character is '-', set the sign flag
    j convert_loop

set_negative:
    li t1, 1            # Set sign flag to 1 (negative)
    addi a1, a1, 1      # Move to the next character
    j convert_loop

convert_loop:
    lbu t0, 0(a1)       # Load the current character
    beqz t0, apply_sign # If null (end of string), apply the sign and finish
    li t2, 48           # ASCII code for '0'
    li t3, 57           # ASCII code for '9'
    blt t0, t2, apply_sign  # If t0 < '0', end conversion
    bgt t0, t3, apply_sign  # If t0 > '9', end conversion

    sub t0, t0, t2      # Convert ASCII character to its integer value
    li  t5, 10
    mul a0, a0, t5      # Multiply current result by 10
    add a0, a0, t0      # Add the integer value to a0
    addi a1, a1, 1      # Move to the next character
    j convert_loop      # Repeat the loop

apply_sign:
    beqz t1, end_atoi   # If the sign flag is 0 (positive), finish
    neg a0, a0          # If negative, negate the result

end_atoi:
    ret                 # Return with the result in a0

