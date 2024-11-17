`timescale 1ns / 1ps

module tb_SYS;

    // Clock and reset
    reg clk;
    reg reset;

    // Instantiate the SYS module
    SYS uut (
        .clk(clk),
        .reset(reset)
    );

    // Generate a clock signal with a period of 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle every 5 ns (100 MHz clock)
    end

    // Test procedure
    initial begin
        // Initialize the reset signal and start the test
        reset = 1;
        #10;
        reset = 0;
        // Initialize all Registers in SYS to zero
        uut.Registers[0] = 32'b0;
        uut.Registers[1] = 32'b0;
        uut.Registers[2] = 32'b0;
        uut.Registers[3] = 32'b0;
        uut.Registers[4] = 32'b0;
        uut.Registers[5] = 32'b0;
        uut.Registers[6] = 32'b0;
        uut.Registers[7] = 32'b0;
        uut.Registers[8] = 32'b0;
        uut.Registers[9] = 32'b0;
        uut.Registers[10] = 32'b0;
        uut.Registers[11] = 32'b0;
        uut.Registers[12] = 32'b0;
        uut.Registers[13] = 32'b0;
        uut.Registers[14] = 32'b0;
        uut.Registers[15] = 32'b0;
        uut.Registers[16] = 32'b0;
        uut.Registers[17] = 32'b0;
        uut.Registers[18] = 32'b0;
        uut.Registers[19] = 32'b0;
        uut.Registers[20] = 32'b0;
        uut.Registers[21] = 32'b0;
        uut.Registers[22] = 32'b0;
        uut.Registers[23] = 32'b0;
        // Wait some cycles and observe the results
	//
	// Monitor the PC and instruction being executed
        $dumpfile("tb_SYS.vcd");
        $dumpvars(0,tb_SYS);
        #100;

        // Display the initial contents of the InstructionMemory and registers
        $display("Instruction Memory and Register File Contents after Reset:");
        $display("InstructionMemory[0] = %h", uut.inst_mem.memory[0]);
        $display("InstructionMemory[1] = %h", uut.inst_mem.memory[1]);
        $display("InstructionMemory[2] = %h", uut.inst_mem.memory[2]);
        $display("InstructionMemory[3] = %h", uut.inst_mem.memory[3]);
        $display("InstructionMemory[4] = %h", uut.inst_mem.memory[4]);
        $display("InstructionMemory[5] = %h", uut.inst_mem.memory[5]);
        $display("InstructionMemory[6] = %h", uut.inst_mem.memory[6]);
        $display("InstructionMemory[7] = %h", uut.inst_mem.memory[7]);
        
        // Check the initial values of some registers
        $display("Initial Register Values:");
        $display("Register[2] = %h", uut.Registers[2]);  // Expected result after ADDI
        $display("Register[3] = %h", uut.Registers[3]);  // Expected result after ADDI
        $display("Register[4] = %h", uut.Registers[4]);  // Expected result after ADD

        // Monitor PC and the register values dynamically
	//
        $dumpfile("tb_SYS.vcd");
        $dumpvars(0,tb_SYS);

        // Run the simulation for a specific period to observe behavior
        #200;

        // Check the final values of some registers and memory
        $display("Final Register and Memory Values:");
        $display("Register[0] = %h", uut.Registers[0]);
        $display("Register[1] = %h", uut.Registers[1]);
        $display("Register[2] = %h", uut.Registers[2]);
        $display("Register[3] = %h", uut.Registers[3]);
        $display("Register[4] = %h", uut.Registers[4]);

        // End the simulation
        $finish;
    end

endmodule

