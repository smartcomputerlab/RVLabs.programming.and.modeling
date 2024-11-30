`timescale 1ns / 1ps

module tb_sign_extension;

    // Define constants
    `define INST_WIDTH 32
    `define OPCODE 7

    // Inputs to the Sign Extension module
    reg [`INST_WIDTH-1:0] i_inst;          // 32-bit instruction input
    reg [`OPCODE-1:0] i_opcode;            // 7-bit opcode

    // Output from the Sign Extension module
    wire [`INST_WIDTH-1:0] immediate_extended;  // Sign-extended immediate output

    // Instantiate the Sign Extension module
    sign_extension uut (
        .i_inst(i_inst),
        .i_opcode(i_opcode),
        .immediate_extended(immediate_extended)
    );

    // Simulation Initialization
    initial begin
        // Set initial values
        i_inst = 32'b0;
        i_opcode = 7'b0;

        // Wait for 10ns
        #10;

        // Test I-Type Instruction (e.g., ADDI)
        i_inst = 32'b000000000001_00001_000_00100_0010011; // I-Type: ADDI x4, x1, 1 (12-bit immediate = 1)
        i_opcode = i_inst[6:0];                            // Extract opcode (0010011)
        #10;
        $display("I-Type (ADDI): Instruction = %b, Immediate = %h (Expected: 00000001)", i_inst, immediate_extended);

        // Test S-Type Instruction (e.g., SW)
        i_inst = 32'b0000000_00100_00001_010_00010_0100011; // S-Type: SW x2, 4(x1) (split 12-bit immediate)
        i_opcode = i_inst[6:0];                             // Extract opcode (0100011)
        #10;
        $display("S-Type (SW): Instruction = %b, Immediate = %h (Expected: 00000004)", i_inst, immediate_extended);

        // Test B-Type Instruction (e.g., BEQ)
        i_inst = 32'b0000000_00001_00010_000_00001_1100011; // B-Type: BEQ x1, x2, offset (13-bit immediate)
        i_opcode = i_inst[6:0];                             // Extract opcode (1100011)
        #10;
        $display("B-Type (BEQ): Instruction = %b, Immediate = %h (Expected: offset sign-extended value)", i_inst, immediate_extended);

        // Test U-Type Instruction (e.g., LUI)
        i_inst = 32'b00000000000000000001_00100_0110111;    // U-Type: LUI x4, imm (20-bit immediate)
        i_opcode = i_inst[6:0];                             // Extract opcode (0110111)
        #10;
        $display("U-Type (LUI): Instruction = %b, Immediate = %h (Expected: 00010000)", i_inst, immediate_extended);

        // Test J-Type Instruction (e.g., JAL)
        i_inst = 32'b000000000001_00000000_00001_1101111;   // J-Type: JAL x1, offset (21-bit immediate)
        i_opcode = i_inst[6:0];                             // Extract opcode (1101111)
        #10;
        $display("J-Type (JAL): Instruction = %b, Immediate = %h (Expected: 00000001)", i_inst, immediate_extended);

        // Finish simulation
        $finish;
    end
      initial begin
    $dumpfile("tb_sign_extension.vcd");
    $dumpvars;
  end


endmodule

