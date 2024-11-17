.section    .data
#output: .space 32                # Reserve 32 bytes for input buffer
buffer: .space 32                # Reserve 32 bytes for output buffer (itoa result)

    .text
    .globl atoi, itoa, _start

# atoi: Convert ASCII string to an unsigned integer
# Input: Address of ASCII string in a1
# Output: Unsigned integer result in a0
atoi:
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


# itoa: Convert integer in a0 to ASCII string
# Input: Integer value in a0, buffer address in a1
# Output: ASCII string in buffer
itoa:
    mv t1, a1                    # t1 will be our working buffer pointer
    li t2, 10                    # Base 10 for conversion

itoa_loop:
    rem t3, a0, t2               # t3 = a0 % 10 (last digit)
    addi t3, t3, 48              # Convert to ASCII ('0' = 48)
    sb t3, 0(t1)                 # Store ASCII character in buffer
    addi t1, t1, 1               # Move to the next buffer position

    div a0, a0, t2               # a0 = a0 / 10
    bnez a0, itoa_loop           # Repeat until a0 == 0

    # Reverse the string
    addi t1, t1, -1              # Move t1 back to the last written character
    mv t3, a1                    # t3 points to start of the string
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
    sb zero, 0(t1)               # Null-terminate the string
    jr ra                        # Return


# Main program to demonstrate atoi and itoa functions
_start:
    # Read input string into buffer
    la a1, buffer                # Load address of buffer into a1
    li a7, 63                    # Syscall number for read (Linux)
    li a0, 0                     # File descriptor 0 (stdin)
    li a2, 32                    # Max characters to read
    ecall                        # Make syscall to read into buffer

    # Convert ASCII string to integer using atoi
    la a1, buffer                # Reload address of input buffer into a1
    jal ra, atoi                 # Call atoi, result will be in a0
    
    li a3, 32
    la a2, buffer
clean:
    sb zero, 0(a2)
    addi a3, a3, -1
    addi a2, a2, 1
    bnez  a3, clean

    # Convert integer to ASCII string using itoa
    la a1, buffer                # Address of output buffer for itoa
    jal ra, itoa                 # Call itoa

    # Print result string (converted integer) to stdout
    li a7, 64                    # Syscall number for write (Linux)
    li a0, 1                     # File descriptor 1 (stdout)
    la a1, buffer                # Address of output buffer
    li a2, 32                    # Number of bytes to write
    ecall                        # Output result

    # Exit program
    li a7, 93                    # Syscall number for exit
    ecall                        # Exit program

