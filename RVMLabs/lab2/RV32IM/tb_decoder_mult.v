`timescale 1ns/1ps
`include "definitions.vh"

module tb_decoder;

    // Parameters
    parameter INST_WIDTH = `INST_WIDTH;
    parameter OPCODE = `OPCODE;
    parameter NUM_REGISTER = `NUM_REGISTER;

    // Inputs to the decoder
    reg [INST_WIDTH-1:0] i_inst;

    // Outputs from the decoder
    wire [OPCODE-1:0] o_opcode;
    wire o_branch;
    wire [1:0] o_result_mux;
    wire [2:0] o_branch_op;
    wire o_mem_write;
    wire o_alu_src_a;
    wire o_alu_src_b;
    wire o_reg_write;
    wire [5:0] o_alu_op;
    wire [$clog2(NUM_REGISTER) - 1: 0] o_rs1_addr;
    wire [$clog2(NUM_REGISTER) - 1: 0] o_rs2_addr;
    wire [$clog2(NUM_REGISTER) - 1: 0] o_rd_addr;

    // Instantiate the Decoder Unit (Unit Under Test)
    decoder uut (
        .i_inst(i_inst),
        .o_opcode(o_opcode),
        .o_branch(o_branch),
        .o_result_mux(o_result_mux),
        .o_branch_op(o_branch_op),
        .o_mem_write(o_mem_write),
        .o_alu_src_a(o_alu_src_a),
        .o_alu_src_b(o_alu_src_b),
        .o_reg_write(o_reg_write),
        .o_alu_op(o_alu_op),
        .o_rs1_addr(o_rs1_addr),
        .o_rs2_addr(o_rs2_addr),
        .o_rd_addr(o_rd_addr)
    );

    // Testbench procedure
    initial begin
        // Test 1: ADD Instruction (R-Type)
        // ADD x5, x6, x7
        i_inst = 32'b0000000_00111_00110_000_00101_0110011; // funct7 = 0000000, rs2 = x7, rs1 = x6, funct3 = 000, rd = x5, opcode = 0110011
        #10;
        $display("Test ADD: o_opcode=%b, o_alu_op=%b, o_reg_write=%b, o_rs1_addr=%d, o_rs2_addr=%d, o_rd_addr=%d",
                 o_opcode, o_alu_op, o_reg_write, o_rs1_addr, o_rs2_addr, o_rd_addr);

        // Test 2: SUB Instruction (R-Type)
        // SUB x5, x6, x7
        i_inst = 32'b0100000_00111_00110_000_00101_0110011; // funct7 = 0100000, rs2 = x7, rs1 = x6, funct3 = 000, rd = x5, opcode = 0110011
        #10;
        $display("Test SUB: o_opcode=%b, o_alu_op=%b, o_reg_write=%b, o_rs1_addr=%d, o_rs2_addr=%d, o_rd_addr=%d",
                 o_opcode, o_alu_op, o_reg_write, o_rs1_addr, o_rs2_addr, o_rd_addr);

        // Test 3: MUL Instruction (R-Type, M-extension)
        // MUL x5, x6, x7
        i_inst = 32'b0000001_00111_00110_000_00101_0110011; // funct7 = 0000001, rs2 = x7, rs1 = x6, funct3 = 000, rd = x5, opcode = 0110011
        #10;
        $display("Test MUL: o_opcode=%b, o_alu_op=%b, o_reg_write=%b, o_rs1_addr=%d, o_rs2_addr=%d, o_rd_addr=%d",
                 o_opcode, o_alu_op, o_reg_write, o_rs1_addr, o_rs2_addr, o_rd_addr);

        // Test 4: Load Word Instruction (I-Type)
        // LW x5, 4(x6)
        i_inst = 32'b000000000100_00110_010_00101_0000011; // imm[11:0] = 4, rs1 = x6, funct3 = 010, rd = x5, opcode = 0000011
        #10;
        $display("Test LW: o_opcode=%b, o_mem_write=%b, o_alu_op=%b, o_reg_write=%b, o_rs1_addr=%d, o_rd_addr=%d",
                 o_opcode, o_mem_write, o_alu_op, o_reg_write, o_rs1_addr, o_rd_addr);

        // Test 5: Store Word Instruction (S-Type)
        // SW x7, 4(x6)
        i_inst = 32'b0000000_00111_00110_010_00010_0100011; // imm[11:5] = 0000000, rs2 = x7, rs1 = x6, funct3 = 010, imm[4:0] = 00100, opcode = 0100011
        #10;
        $display("Test SW: o_opcode=%b, o_mem_write=%b, o_alu_op=%b, o_rs1_addr=%d, o_rs2_addr=%d",
                 o_opcode, o_mem_write, o_alu_op, o_rs1_addr, o_rs2_addr);

        // Test 6: Branch Equal (B-Type)
        // BEQ x6, x7, offset 8
        i_inst = 32'b000000_00111_00110_000_00001_1100011; // imm[12] = 0, imm[10:5] = 000000, rs2 = x7, rs1 = x6, funct3 = 000, imm[4:1] = 0001, imm[11] = 0, opcode = 1100011
        #10;
        $display("Test BEQ: o_opcode=%b, o_branch=%b, o_branch_op=%b, o_rs1_addr=%d, o_rs2_addr=%d",
                 o_opcode, o_branch, o_branch_op, o_rs1_addr, o_rs2_addr);

        // Finish simulation
        #10;
        $finish;
    end
    initial begin
    $dumpfile("tb_decoder_mult.vcd");
    $dumpvars;
    end

endmodule

