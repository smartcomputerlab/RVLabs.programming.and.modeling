.section        .data
buffer:         .space 16             # Allocate space for the input integer (max 11 digits + null terminator)
.section        .rodata
prompt:         .ascii "Enter an integer: " # Prompt message
.section        .rodata
newline:        .ascii  "\n"

    .text
    .global _start
    .extern  factorial

_start:
# Print the prompt message
    li a0, 1                        # File descriptor for stdout
    la a1, prompt                   # Load address of prompt message
    li a2, 20                       # Length of the prompt string
    li a7, 64                       # Syscall number for write (Linux RISC-V write syscall is 64)
    ecall                           # Print prompt message

# Read the integer value from stdin
    li a0, 0                        # File descriptor for stdin
    la a1, buffer                   # Load address of buffer
    li a2, 12                       # Max number of bytes to read
    li a7, 63                       # Syscall number for read (Linux RISC-V read syscall is 63)
    ecall                           # Read input into buffer

# Convert the input string to an integer
    li t0, 0                        # Initialize integer result in t0
    li t1, 1                        # Initialize multiplier for position value (1 for unit place)
    li t2, 0                        # Initialize buffer index

convert_loop:                       # ascii to integer : atoi
    add a3, a1, t2
    lb t3, 0(a3)                    # Load a byte from buffer
    beq t3, zero, end_convert       # If null terminator, we are done
    li a4, 10
    beq t3, a4, end_convert         # If newline (or CR), stop (optional for this case)

    # Convert ASCII character to integer
    addi t3, t3, -48                 # Convert ASCII to integer (ASCII '0' is 48)
    li a4, 10
    mul t0, t0, a4                  # Multiply current result by 10
    add t0, t0, t3                  # Add the new digit to result
    addi t2, t2, 1                  # Move to the next character
    j convert_loop                  # Repeat conversion

end_convert:
    mv  a0, t0
    call factorial
    mv t4, a0
# prepare reverse conversion        integer to ascii : itoa
    # Convert integer in t0 to ASCII string in reverse order
    la a1, buffer                   # Load address of buffer for output
    addi a2, t2, 1                  # Length of digits to output
    #mv t4, t0                       # Move the integer to t4 for conversion
    li t5, 0                        # Initialize counter for digits

    #mv  a0, t0
    #call factorial
    #²mv t4, a0

# Create the string in reverse order
reverse_convert:
    li a4, 10
    rem t6, t4, a4                  # Get last digit
    addi t6, t6, '0'                # Convert to ASCII
    add a4, a1, t5
    sb t6, 0(a4)               # Store ASCII character in buffer
    addi t5, t5, 1                  # Move to next position
    li a4, 10
    div t4, t4, a4                  # Remove last digit
    bnez t4, reverse_convert        # Continue if t4 is not zero

    # Null-terminate the string
    la a1, buffer
    add t4, a1,t5
    sb zero, 0(t4)             # Add null terminator at the end of the string

    # Output the integer string to stdout
    la a3, buffer
    li a0, 1                        # File descriptor for stdout

next_char:
    addi t5, t5, -1
    add a1, a3, t5                   # Load address of buffer
    li  a2, 1                       # Length of the string (in characters, without null terminator)
    li a7, 64                       # Syscall number for write (Linux RISC-V write syscall is 64)
    ecall                           # Print the integer as string
    bnez t5, next_char

# print new line    
    li a0, 1                        # File descriptor for stdout
    la a1, newline                   # Load address of buffer
    li a2, 1                       # Length of the string (in characters, without null terminator)
    li a7, 64                       # Syscall number for write (Linux RISC-V write syscall is 64)
    ecall                           # Print the integer as string

# Exit program
    li a7, 93                       # Syscall number for exit
    li a0, 0                        # Exit code 0 (success)
    ecall                           # Exit


