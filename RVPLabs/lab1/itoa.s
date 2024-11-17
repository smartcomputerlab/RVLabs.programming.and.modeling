    .data
buffer:
    .space 21           # Reserve space for up to 20 characters + null terminator (for a 64-bit integer)

    .text
    .globl itoa
itoa:
    # Arguments:
    # a0 = integer to convert

    addi sp, sp, -32    # Create space on stack for saved registers and variables
    sd ra, 24(sp)       # Save return address
    sd a0, 16(sp)       # Save original value of a0

    li a1, 10           # a1 = base (10 for decimal)
    la a2, buffer       # a2 = address of the buffer (end of buffer)
    addi a2, a2, 20     # Start filling buffer from the rightmost position

    li t0, 0            # Sign flag (0 = positive, 1 = negative)
    bltz a0, negative   # Check if the number is negative
    li t5, 0

convert_loop:
    addi t5, t5, 1
    rem t1, a0, a1      # t1 = remainder (digit to add)
    addi t1, t1, 48     # Convert remainder to ASCII ('0' = 48)
    sb t1, 0(a2)        # Store the ASCII character in the buffer
    addi a2, a2, -1     # Move buffer pointer left
    div a0, a0, a1      # Divide number by 10
    bnez a0, convert_loop # Repeat until quotient is 0
    j end_conversion

negative:
    li t0, 1            # Mark number as negative
    neg a0, a0          # Take the absolute value
    addi t5, t5, 1
    j convert_loop

end_conversion:
    beqz t0, print_number # If not negative, skip adding '-'
    li t1, 45            # ASCII for '-'
    sb t1, 0(a2)         # Store '-' in the buffer
    addi a2, a2, -1      # Move buffer pointer left
    
print_number:
    addi a2, a2, 1       # Move pointer to the start of the number
    li a7, 64            # System call for write (Linux/RISC-V)
    li a0, 1             # File descriptor 1 (stdout)
    mv a1, a2            # Start of the string in buffer
    mv a2, t5            # Length of the buffer (max, trimmed automatically)
    ecall                # Make the system call

    ld ra, 24(sp)        # Restore return address
    addi sp, sp, 32      # Restore stack
    ret                  # Return from the function

