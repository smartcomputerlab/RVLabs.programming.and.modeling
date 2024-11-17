    .data
buffer: .space 32                # Reserve 32 bytes for input buffer
output: .space 32                # Reserve 32 bytes for output buffer (itoa result)

    .text
    .globl  _start
    .extern atoi, factorial, itoa


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

    #call factorial		 # argument and result in a0
    jal ra, factorial

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

