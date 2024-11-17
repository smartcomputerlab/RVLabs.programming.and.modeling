    .data
prompt:      .asciz "Enter a number: "       # Prompt message for user input
result_msg:  .asciz "Factorial is: "         # Message to display before printing the result
format_in:   .asciz "%ld"                    # Format for reading a 64-bit integer with scanf
format_out:  .asciz "%ld\n"                  # Format for printing a 64-bit integer with printf

    .bss
number:    .dword 0           # Space to store input number (64-bit)
result:    .dword 0           # Space to store factorial result (64-bit)

    .text
    .global _start
    .extern factorial         # Declare external factorial function

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
    li a7, 93                   # Load 10 into a7 to signify exit syscall
    ecall                      # Exit

