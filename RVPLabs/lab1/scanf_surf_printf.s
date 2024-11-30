    .data
fmt_scanf:  .asciz "%f"        # Format string for scanf (reading a long integer)
radius:  .float 10.0                 # Radius of the circle, adjust this value as needed
pi:      .float 3.1415927           # Approximation of pi in single precision
area:  .float 0.0                 # Variable to store the result
fmt_printf: .asciz "Surface: %f\n"

    .text
    .global _start
_start:
    .option   norelax
    la  gp, __global_pointer$
    la a0, fmt_scanf            # First argument for scanf (the format string)
    la a1, radius         # Second argument for scanf (address of the variable)
    call scanf

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
    lla     a4, area
    fsw     ft3, 0(a4)            # Store the result in 'result' (single-precision)

    fcvt.d.s     ft3, ft3
    fmv.x.d      a1, ft3
    la      a0, fmt_printf
    call    printf

    # Exit the program (using system call for exit)
    li      a7, 93                 # System call number for exit in RISC-V (64-bit)
    ecall                           # Exit the program

