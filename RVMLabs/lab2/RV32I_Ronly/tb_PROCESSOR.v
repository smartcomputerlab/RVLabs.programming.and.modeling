`timescale 1ns / 1ps

module tb_PROCESSOR;

    // Signals
    reg clk;
    reg reset;

    // Instantiate the Processor
    PROCESSOR uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Reset and Stimulus
    initial begin
        // Initialize reset
        reset = 1;
        #15;            // Hold reset for 15 ns
        reset = 0;

        // Run simulation for a while to observe behavior
        #200;

        // Finish simulation
        $stop;
    end
    initial begin
       uut.datapath.reg_file.regfile[0] = 32'b0;
       uut.datapath.reg_file.regfile[1] = 32'b0;
       uut.datapath.reg_file.regfile[2] = 32'b0;
       uut.datapath.reg_file.regfile[3] = 32'b0;
       uut.datapath.reg_file.regfile[4] = 32'b0;
       uut.datapath.reg_file.regfile[5] = 32'b0;
       uut.datapath.reg_file.regfile[6] = 32'b0;
       uut.datapath.reg_file.regfile[7] = 32'b0;
       uut.datapath.reg_file.regfile[8] = 32'b0;
       uut.datapath.reg_file.regfile[9] = 32'b0;
       uut.datapath.reg_file.regfile[10] = 32'b0;
       uut.datapath.reg_file.regfile[11] = 32'b0;
       uut.datapath.reg_file.regfile[12] = 32'b0;
       uut.datapath.reg_file.regfile[13] = 32'b0;
       uut.datapath.reg_file.regfile[14] = 32'b0;
       uut.datapath.reg_file.regfile[15] = 32'b0;
    end

    // Monitor outputs for debugging
    initial begin
        $monitor("Time: %0t | PC: %h | Instruction: %h | Zero Flag: %b", 
                 $time, uut.ifu.pc, uut.inst_mem.instruction, uut.datapath.zero);
        $dumpfile("tb_PROCESSOR.vcd");  // Create the VCD file
        $dumpvars(0, tb_PROCESSOR);     // Dump variables
    end

endmodule

