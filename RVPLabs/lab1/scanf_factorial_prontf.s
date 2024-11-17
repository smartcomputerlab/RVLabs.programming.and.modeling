    .data
prompt:      .asciz "Enter a number: "       # Prompt message
result_msg:  .asciz "Factorial is: "         # Message for displaying the result
format_in:   .asciz "%ld"                    # Format for reading a 64-bit integer with scanf
format_out:  .asciz "%ld\n"                  # Format for printing a 64-bit integer with printf

    .bss
number:    .dword 0           # Space to store input number (64-bit)
result:    .dword 0           # Space to store factorial result (64-bit)

    .text
    .global _start
    .global factorial

_start:
    # Print prompt message
    la a0, prompt              # Load address of prompt message
    call printf                # Call printf to display prompt

    # Read user input
    la a0, format_in           # Load address of format string for input
    la a1, number              # Load address where input will be stored
    call scanf                 # Call scanf to read input into 'number'

    # Load the number and call the factorial function
    ld a0, number              # Load the input number into a0 (64-bit integer argument for factorial)
    call factorial             # Call factorial function; result will be in a0

    # Store the result and print result message
    la a2, result
    sd a0, 0(a2)              # Store the factorial result in 'result'
    la a0, result_msg          # Load address of result message
    call printf                # Call printf to display result message

    # Print factorial result
    la a0, format_out          # Load address of output format string
    ld a1, result              # Load the factorial result from memory to a1 (64-bit integer)
    call printf                # Call printf to output the factorial result

    # Exit program
    li a7, 93                  # Load 93 into a7 to signify exit syscall
    ecall                      # Exit

# Factorial Function (recursive)
# Arguments:
#   a0 - integer n (input, 64-bit)
# Returns:
#   a0 - factorial(n) (result, 64-bit)
factorial:
    addi sp, sp, -16           # Allocate stack space for ra and n
    sd ra, 8(sp)               # Save return address to stack (64-bit)
    sd a0, 0(sp)               # Save n (a0) to stack (64-bit)

    # Base case: if n <= 1, return 1
    li t0, 1                   # Load 1 into t0
    ble a0, t0, factorial_base # If n <= 1, go to base case

    # Recursive case: n * factorial(n - 1)
    addi a0, a0, -1            # Compute n - 1
    call factorial             # Recursive call: factorial(n - 1)
    ld t1, 0(sp)               # Restore n from stack to t1 (64-bit)
    mul a0, a0, t1             # a0 = n * factorial(n - 1) (64-bit multiplication)

    j factorial_end            # Jump to end of function

factorial_base:
    li a0, 1                   # Base case result (factorial(0) or factorial(1) = 1)

factorial_end:
    ld ra, 8(sp)               # Restore return address (64-bit)
    addi sp, sp, 16            # Deallocate stack space
    jr ra                      # Return to caller

