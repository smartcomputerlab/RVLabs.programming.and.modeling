.section    .data
buffer1: .space 32                # Reserve 32 bytes for the first input buffer
.section    .data
buffer2: .space 32                # Reserve 32 bytes for the second input buffer
.section    .data
output:  .space 32                # Reserve 32 bytes for output buffer (itoa result)

    .text
    .globl _start
    .extern power                 # Declare the external power function

# atoi: Convert ASCII string to an unsigned integer
# Input: Address of ASCII string in a1
# Output: Unsigned integer result in a0
atoi:
    li a0, 0                      # Initialize result register a0 to 0
    li t0, 10                     # Set t0 to 10 (for multiplying by 10)
    li t1, 48                     # ASCII '0'

atoi_loop:
    lb t3, 0(a1)                  # Load the next byte from the address in a1
    li t4, 10
    beq t3, t4, atoi_end           # If new_line terminator, end conversion
    addi a1, a1, 1                # Increment string pointer to the next byte

    sub t3, t3, t1                # Convert ASCII to integer (t3 = t3 - '0')
    mul a0, a0, t0                # Multiply result by 10
    add a0, a0, t3                # Add the current digit to the result

    j atoi_loop                   # Repeat for next character

atoi_end:
    jr ra                         # Return to caller with result in a0

# itoa: Convert integer in a0 to ASCII string
# Input: Integer value in a0, buffer address in a1
# Output: ASCII string in buffer
itoa:
    mv t1, a1                     # t1 will be our working buffer pointer
    li t2, 10                     # Base 10 for conversion

itoa_loop:
    rem t3, a0, t2                # t3 = a0 % 10 (last digit)
    addi t3, t3, 48               # Convert to ASCII ('0' = 48)
    sb t3, 0(t1)                  # Store ASCII character in buffer
    addi t1, t1, 1                # Move to the next buffer position

    div a0, a0, t2                # a0 = a0 / 10
    bnez a0, itoa_loop            # Repeat until a0 == 0
    sb  zero, 0(t1)

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
    jr ra                         # Return

# Main program to read two integers, compute power, and output result
_start:
    # Read first input string into buffer1
    la a1, buffer1                # Load address of buffer1 into a1
    li a7, 63                     # Syscall number for read (Linux)
    li a0, 0                      # File descriptor 0 (stdin)
    li a2, 32                     # Max characters to read
    ecall                         # Read into buffer1

    # Convert first ASCII string to integer using atoi
    la a1, buffer1                # Reload address of buffer1 into a1
    jal ra, atoi                  # Call atoi, result will be in a0 (first integer)

    # Move first integer result from a0 to a2 for safe-keeping
    mv a3, a0                     # Store first integer in a2

    # Read second input string into buffer2
    la a1, buffer1                # Load address of buffer2 into a1
    li a7, 63                     # Syscall number for read (Linux)
    li a0, 0                      # File descriptor 0 (stdin)
    li a2, 32                     # Max characters to read
    ecall                         # Read into buffer2

    # Convert second ASCII string to integer using atoi
    la a1, buffer1                # Reload address of buffer2 into a1
    jal ra, atoi                  # Call atoi, result will be in a0 (second integer)

    # Move second integer result from a0 to a1 for power function argument
    mv a1, a0                     # Store second integer in a1
    mv a0, a3                     # Restore first integer to a0

    # Call external power function
    jal ra, power                 # Call power function, a0 holds base, a1 holds exponent

    # Convert result to ASCII string using itoa
    la a1, buffer1                 # Address of output buffer for itoa
    jal ra, itoa                  # Call itoa to convert power result in a0

    # Print result string (power result) to stdout
    li a7, 64                     # Syscall number for write (Linux)
    li a0, 1                      # File descriptor 1 (stdout)
    la a1, buffer1                 # Address of output buffer
    li a2, 32                     # Max characters to write
    ecall                         # Output result

    # Exit program
    li a7, 93                     # Syscall number for exit
    ecall                         # Exit program

