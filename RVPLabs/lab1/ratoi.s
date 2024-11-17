# atoi: Convert ASCII string to an unsigned integer
# Input: Address of ASCII string in a1
# Output: Unsigned integer result in a0

    .data
buffer: .space 32                # Reserve 32 bytes for input buffer

    .text
    .globl ratoi
ratoi:
    la a1, buffer                # Load the address of the buffer into a1
    li a7, 63                    # Syscall number for read (Linux)
    li a0, 0                     # File descriptor 0 (stdin)
    li a2, 32                    # Max characters to read
    ecall                        # Make syscall to read into buffer

    li a0, 0                     # Initialize result register a0 to 0
    li t0, 10                    # Set t0 to 10 (for multiplying by 10)
    li t1, 48                    # ASCII '0'
    li t2, 57                    # ASCII '9'

atoi_loop:
    lb t3, 0(a1)                 # Load the next byte from the address in a1
    beq t3, zero, atoi_end          # If null terminator, end conversion
    addi a1, a1, 1               # Increment string pointer to the next byte

    blt t3, t1, atoi_loop        # Skip if character < '0'
    bgt t3, t2, atoi_loop        # Skip if character > '9'

    sub t3, t3, t1               # Convert ASCII to integer (t3 = t3 - '0')
    mul a0, a0, t0               # Multiply result by 10
    add a0, a0, t3               # Add the current digit to the result

    j atoi_loop                  # Repeat for next character

atoi_end:
    jr ra                        # Return to caller with result in a0



