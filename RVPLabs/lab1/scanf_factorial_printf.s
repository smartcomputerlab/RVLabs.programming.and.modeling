    .data
    fmt_scanf:  .asciz "%u"        # Format string for scanf (reading a long integer)
    fmt_printf: .asciz "Factorial (a!) is: %u\n"  # Format string for printf (printing a long integer)
    result: .word 0           # Reserve space to store the result of the multiplication
    base: .word 0           # Reserve space to store the result of the multiplication
    .text
    .globl _start
    .extern factorial
    .extern factorial_rec
# Main Program
_start:
    .option norelax
    la gp, __global_pointer$
    # Load the address of the format string ("%ld") into a0 (first argument for scanf)
    la a0, fmt_scanf            # First argument for scanf (the format string)
    la a1, base         # Second argument for scanf (address of the variable)
    call scanf
    la  t1, base
    lw  a0, 0(t1)
    #call  factorial
    call  factorial_rec
    mv t0, a0
    # Load the address of the printf format string ("You entered: %ld\n") into a0
    la a0, fmt_printf           # First argument for printf (format string)
    mv a1, t0               # Load the product  value 
    # Call printf
    call printf                 # Use the provided printf function to print output
    # Exit the program
    li a7, 93             # Load the exit ecall code (93) into a7
    ecall                 # Make the exit ecall to terminate the program

