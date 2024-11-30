
    .data
    fmt_scanf:  .asciz "%ld"        # Format string for scanf (reading a long integer)
    fmt_printf: .asciz "You entered: %ld\n"  # Format string for printf (printing a long integer)
    multiplier:     .quad 0             # Reserve space for a 64-bit integer
    multiplicand:     .quad 0             # Reserve space for a 64-bit integer
    result:     .quad 0             # Reserve space for a 64-bit integer
    .text
    .globl _start
    .extern u_mult

_start:
    .option norelax
    la  gp, __global_pointer$
    # Step 1: Read an integer from the user using scanf
    # Load the address of the format string ("%ld") into a0 (first argument for scanf)
    la a0, fmt_scanf            # First argument for scanf (the format string)
    # Load the address of the variable 'number' into a1 (second argument for scanf)
    la a1, multiplier               # Second argument for scanf (address of the variable)
    # Call scanf
    call scanf                  # Use the provided scanf function to read input

    la a0, fmt_scanf            # First argument for scanf (the format string)
    # Load the address of the variable 'number' into a1 (second argument for scanf)
    la a1, multiplicand               # Second argument for scanf (address of the variable)
    # Call scanf
    call scanf                  # Use the provided scanf function to read input

    la  t1, multiplier
    ld  a0, 0(t1)

    la  t1, multiplicand
    ld  a1, 0(t1)

    call u_mult
    la  t1, result
    sd  a0, 0(t1)                  # load number - result
    mv  a1, a0

    # Step 2: Print the entered integer using printf
    # Load the address of the printf format string ("You entered: %ld\n") into a0
    la a0, fmt_printf           # First argument for printf (format string)
    # Load the value of 'number' into a1 (second argument for printf)
    # Call printf
    call printf                 # Use the provided printf function to print output
    # Step 3: Exit the program
    li a7, 93                   # syscall number for exit (in RV64)
    li a0, 0                    # exit code 0 (success)
    ecall                       # Exit the program
