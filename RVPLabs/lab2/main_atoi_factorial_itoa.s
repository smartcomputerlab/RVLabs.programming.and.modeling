    .text
    .globl _start
    .extern itoa       # Declare external itoa function
    .extern factorial  # Declare external factorial function

_start:
    .option norelax
    la  gp, __global_pointer$

    call atoi           # Load the value 5 into a0 (calculate 5!)
    call factorial     # Call the factorial function
    call itoa          # Convert the result in a0 to ASCII and print it
    # Exit program
    li a7, 93          # System call number for exit (Linux/RISC-V)
    li a0, 0           # Exit code 0 (success)
    ecall              # Make the system call

