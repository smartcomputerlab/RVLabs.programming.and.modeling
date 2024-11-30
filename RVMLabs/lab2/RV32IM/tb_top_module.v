`timescale 1ns / 1ps
`include "definitions.vh"

module tb_top_module;

    // Parameters
    parameter DATA_WIDTH = `DATA_WIDTH;

    // Inputs to the top module
    reg clk;
    reg rst;

    // Output from the top module
    wire [DATA_WIDTH-1:0] debug;

    // Instantiate the Top Module (Unit Under Test)
    top uut (
        .clk(clk),
        .rst(rst),
        .debug(debug)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 time unit clock period (50% duty cycle)

    // Task to initialize instruction memory (used as an example)
    task initialize_instruction_memory;
        begin
            // Load some basic instructions into instruction memory
            // Assuming the top module has direct access to instruction memory
            // These instructions are for example purposes only
            // Additional instructions can be loaded similarly
        end
    endtask

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;

        // Apply Reset
        #10;
        rst = 0;

        // Initialize Instruction Memory
        initialize_instruction_memory();

        // Release Reset
        #10;
        rst = 1;

        // Observe the Debug Output
        #100;

        // Check debug outputs at different points in time
        $display("Time: %0t, Debug Output: %h", $time, debug);

        #50;
        $display("Time: %0t, Debug Output: %h", $time, debug);

        #50;
        $display("Time: %0t, Debug Output: %h", $time, debug);

        // Finish simulation
        #200;
        $finish;
    end
    initial begin
    $dumpfile("tb_top_module.vcd");
    $dumpvars;
    end

endmodule

