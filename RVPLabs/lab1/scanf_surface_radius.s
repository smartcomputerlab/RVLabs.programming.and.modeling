    .data
prompt:      .asciz "Enter a number: "       # Prompt message for user input
float_in:   .asciz "%f"                    # Format for reading a 64-bit integer with scanf
pi:      .float 3.1415927           # Approximation of pi in single precision
result:  .float 0.0                 # Variable to store the result
fmt_printf: .asciz "Surface: %f\n"
radius:    .float 0.0           # Space to store input number (float)

    .text
    .global _start

_start:
    # Print prompt message
    la a0, prompt              # Load address of prompt message
    call printf                # Call printf to display prompt

    # Read user input
    la a0, float_in           # Load address of format string for input
    la a1, radius              # Load address where input will be stored
    call scanf                 # Call scanf to read input into 'number'
    # Load the radius and pi into floating-point registers
    lla     a4 , radius
    flw     ft0, 0(a4)            # Load radius (r) into ft0 (single-precision)
    lla     a5, pi
    flw     ft1, 0(a5)                # Load pi into ft1 (single-precision)

    # Calculate r^2 (square of the radius)
    fmul.s  ft2, ft0, ft0          # ft2 = r * r (single-precision)

    # Calculate area = pi * r^2
    fmul.s  ft3, ft1, ft2          # ft3 = pi * (r * r) (single-precision)

    # Store the result back to memory
    lla     a4, result
    fsw     ft3, 0(a4)            # Store the result in 'result' (single-precision)

    fcvt.d.s     ft3, ft3
    fmv.x.d      a1, ft3
    la      a0, fmt_printf
    call    printf

    # Exit the program (using system call for exit)
    li      a7, 93                 # System call number for exit in RISC-V (64-bit)
    ecall                           # Exit the program

