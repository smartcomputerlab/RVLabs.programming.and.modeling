// tb_simple_module.v
`timescale 1ns/1ps
module tb_simple_module;
    reg a;		// Inputs
    reg b;
    wire y;	    // Output
    // Instantiate the design under test (DUT)
    simple_module dut (.a(a), .b(b), .y(y));
    // Testbench process
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        // Simulation sequence
        #10 a = 1;
        #10 b = 1;
        #10 a = 0;
        #10 b = 0;
        #10 a = 1; b = 1;
        #10;
        // End the simulation
        $finish;
    end
    // Dumping the waveform for GTKWave
    initial begin
        $dumpfile("tb_simple_module.vcd");  // Create the VCD file
        $dumpvars(0, tb_simple_module);     // Dump variables
    end
endmodule

