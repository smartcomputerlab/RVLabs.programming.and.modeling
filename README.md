


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

## Getting Started
This is an example of how you may give instructions on setting up your project locally. To get a local copy up and running follow these simple example steps.

### Setting up instructions
Before we begin to run our processor we must initialize the instruction memory with the desired sequence of instructions that we want to execute. By default 8 instructions are included that will execute in that particular sequence of initialization.

### Initializing the register file
In order to implement instructions we must have values in the register to act upon, these values can be initialized in the register file. By default each register is initialized to have a value the same as the register number - 1. Example: Register 14 will have value 13.

### Running the processor
Once the above initializations have been done as desired, compile the file "Processor_tb.v" using iverilog using the following command:
+ compilation
  
> vvp gen-compiled
