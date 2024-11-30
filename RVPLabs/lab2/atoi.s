    .data
buffer: .space 32           # Reserve space for the input buffer (32 bytes)
buffer_len: .word 0         # Length of the input string

    .text
    .globl atoi

atoi:
    # Read a string from stdin
    li a7, 63               # Syscall for reading (sys_read)
    li a0, 0                # File descriptor for stdin (0)
    la a1, buffer           # Load address of buffer
    li a2, 32               # Max number of bytes to read
    ecall                   # Perform syscall (read)

# Function: ascii_to_int
# Description:
#   Reads an ASCII string from a buffer and converts it to an integer.
# Arguments:
#   a1: Address of the ASCII buffer in memory (input buffer)
# Returns:
#   a0: Integer value of the ASCII string
ascii_to_int:
    li a0, 0              # Initialize result to 0 (a0 will hold the final integer)
    li t0, 0              # Temporary register for looping through the string
    li t1, 10             # Load the value 10 to t1 for multiplying (base 10)
ascii_to_int_loop:
    lbu t0, 0(a1)         # Load the current byte from the address in a1
    li  t3, 10
    beq t0, t3, ascii_to_int_end # If the current byte is newline (ASCII 10), end loop
    beq t0, zero, ascii_to_int_end # If the current byte is null terminator (0), end loop
    # Convert ASCII character to numeric value
    li t2, '0'            # Load ASCII value of '0' into t2
    sub t0, t0, t2        # t0 = t0 - '0' (convert ASCII to numeric)
    # Multiply current result by 10 and add the new digit
    mul a0, a0, t1        # a0 = a0 * 10
    add a0, a0, t0        # a0 = a0 + current digit
    addi a1, a1, 1        # Increment pointer to the next character
    j ascii_to_int_loop   # Repeat the loop
ascii_to_int_end:
    ret                   # Return to caller (result is in a0)                  # Return to caller (result is in a0)

