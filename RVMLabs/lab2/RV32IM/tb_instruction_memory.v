`timescale 1ns / 1ps

module tb_instruction_memory;

    // Define constants
    `define INST_WIDTH 32

    // Parameters
    parameter MEM_SIZE = 1024;

    // Inputs to the Instruction Memory
    // reg clk;                                      // Clock signal
    reg [$clog2(MEM_SIZE)-1:0] addr;              // Address to fetch the instruction

    // Output from the Instruction Memory
    wire [`INST_WIDTH-1:0] inst;                  // Fetched instruction

    // Instantiate the Instruction Memory module
    instruction_memory #(
        .MEM_SIZE(MEM_SIZE)
    ) uut (
     //   .clk(clk),
        .addr(addr),
        .inst(inst)
    );

    // Clock Generation
    // always #5 clk = ~clk; // Generate clock signal with 10ns period

    initial begin
    uut.memory[31] = 32'h00000093;  // Example: ADDI x1, x0, 0
    uut.memory[32] = 32'h00100113;  // Example: ADDI x2, x0, 1
    uut.memory[33] = 32'h00208193;  // Example: ADDI x3, x1, 2
    uut.memory[34] = 32'h00A00293; // Example: ADDI x5, x0, 10
    uut.memory[35] = 32'h01400313; // Example: ADDI x6, x0, 20
    // Other instructions can be initialized as needed
    end
    // Simulation Initialization
    initial begin
        // Initialize signals
        //clk = 0;
        addr = 0;

        // Load instructions into memory for testing
        // Instructions are loaded using the 'initial' block within the instruction memory.
        // This typically involves creating an initial block inside 'instruction_memory' to
        // pre-load the memory with some values for simulation.

        // Wait for 10ns
        #10;

        // Test fetching the instruction at address 31
        addr = 31;
        #10;
        $display("Address: %d, Instruction: %h (Expected: value set in initial block of instruction_memory)", addr, inst);

        // Test fetching the instruction at address 32
        addr = 32;
        #10;
        $display("Address: %d, Instruction: %h (Expected: value set in initial block of instruction_memory)", addr, inst);

        // Test fetching the instruction at address 33
        addr = 33;
        #10;
        $display("Address: %d, Instruction: %h (Expected: value set in initial block of instruction_memory)", addr, inst);

        // Test fetching the instruction at address 34
        addr = 34;
        #10;
        $display("Address: %d, Instruction: %h (Expected: value set in initial block of instruction_memory)", addr, inst);

        // Test fetching the instruction at address 35
        addr = 35;
        #10;
        $display("Address: %d, Instruction: %h (Expected: value set in initial block of instruction_memory)", addr, inst);

        // Finish simulation
        #20;
        $finish;
    end

    initial begin
    $dumpfile("tb_instruction_memory.vcd");
    $dumpvars;
    end


endmodule

