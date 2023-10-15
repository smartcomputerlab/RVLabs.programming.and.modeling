


# RISC-V.programming.and.modeling
This repository contains the preparations for RISC-V labs. The project is based on simple RISC-V (RV32R) model in Verilog.
<picture>
 <img alt="YOUR-ALT-TEXT" src="images/RISCV.flow.proc.drawio.png">
</picture>

# Project structure
+ Each sub-unit is created in its own directory
+ Each directory contains the modules used in this particular unit
+ Additionally it consists of testbenc used to test and debug those modules
+ The final processor implementation is in the directory - Processor
+ This uses all the relevant units and integrates them to provide working processor

## Tools
### iVerilog:
While there are many compilers for verilog present, not many of them are open source, and even fewer are robust, user-friendly and updated regularly. Icarus Verilog checks all boxes and can be learnt easily with this really helpful wiki setup for it.

### GTKWave:
Another really powerful open source tool that was essential in building this project was GTKWave. It helps to view vcd and other waveforms. Really important for debugging and understanding if dependencies of different signals are as described by you.
