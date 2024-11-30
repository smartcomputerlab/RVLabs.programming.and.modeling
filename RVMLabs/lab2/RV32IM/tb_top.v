`timescale 1ns / 1ps

module tb_top;

    // Inputs to the Top Module
    reg clk;           // Clock signal
    reg rst;           // Reset signal

    // Instantiate the Top Module
    top uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation
    always #5 clk = ~clk; // Generate clock signal with 10ns period

    // Simulation Initialization
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;        // Apply reset initially

        // Apply reset for a few cycles
        #20;
        rst = 0;        // Deassert reset after 20ns

        // Monitor PC, ALU Output, Register Values, etc.
        // Note: These signals should be exposed or connected to output ports of `top.v` to observe them in this testbench.
        $monitor("Time = %0t | PC = %h | Instruction = %h | ALU Result = %h | Branch Taken = %b", 
                 $time, uut.pc, uut.instruction, uut.alu_result, uut.branch_taken);

        // Run simulation for a specified amount of time
        #2000;          // Run simulation for 2000ns

        // Finish the simulation
        $finish;
    end

    // Load instructions into instruction memory for testing
    initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars;

        // Instructions can be loaded to instruction memory through an initial block
        // This should be done within the `instruction_memory` module. You could modify
        // `instruction_memory` to allow loading from a memory file for flexibility.
        // For simplicity, adding instructions directly for demonstration purposes.

        // Initialize some example instructions here if needed.
        // You can modify the `instruction_memory` module to include an initial block 
        // that loads specific instructions, such as:
        /*
        initial begin
            memory[0] = 32'h00000093;  // ADDI x1, x0, 0
            memory[1] = 32'h00100113;  // ADDI x2, x0, 1
            memory[2] = 32'h00208193;  // ADDI x3, x1, 2
            // Add more instructions as needed...
        end
        */
    end

endmodule

