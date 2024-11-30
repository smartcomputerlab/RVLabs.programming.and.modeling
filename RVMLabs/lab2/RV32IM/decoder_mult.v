`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module decoder (
    // INPUT
    input wire [`INST_WIDTH-1:0] i_inst,
    
    // OUTPUT
    output wire [`OPCODE-1:0] o_opcode,
    output reg o_branch,
    output reg [1:0] o_result_mux,  // ALU = 2'b00, PC+4 = 2'b01, DATA_MEM = 2'b10
    output reg [2:0] o_branch_op,
    output reg o_mem_write,
    output reg o_alu_src_a,         // 1'b0 = REG_A, 1'b1 = PC
    output reg o_alu_src_b,         // 1'b0 = REG_B, 1'b1 = IMME
    output reg o_reg_write,
    output reg [5:0] o_alu_op,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs1_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs2_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rd_addr
);

    // Extract fields from instruction
    assign o_opcode = i_inst[6:0];
    assign o_rd_addr = i_inst[11:7];
    assign o_rs1_addr = i_inst[19:15];
    assign o_rs2_addr = i_inst[24:20];

    always @(*) begin
        // Default assignments to prevent latches
        o_branch = 1'b0;
        o_result_mux = 2'b00;
        o_branch_op = 3'b000;
        o_mem_write = 1'b0;
        o_alu_src_a = 1'b0;
        o_alu_src_b = 1'b0;
        o_reg_write = 1'b0;
        o_alu_op = `OP_ALU_NOP;

        case (o_opcode)
            // R-type Instructions
            7'b0110011: begin
                o_alu_src_a = 1'b0; // ALU Source A is register
                o_alu_src_b = 1'b0; // ALU Source B is register
                o_reg_write = 1'b1; // Write to register
                case ({i_inst[31:25], i_inst[14:12]})
                    // ADD
                    {7'b0000000, 3'b000}: o_alu_op = `OP_ALU_ADD;
                    // SUB
                    {7'b0100000, 3'b000}: o_alu_op = `OP_ALU_SUB;
                    // OR
                    {7'b0000000, 3'b110}: o_alu_op = `OP_ALU_OR;
                    // XOR
                    {7'b0000000, 3'b100}: o_alu_op = `OP_ALU_XOR;
                    // SLT
                    {7'b0000000, 3'b010}: o_alu_op = `OP_ALU_SLT;
                    // SLTU
                    {7'b0000000, 3'b011}: o_alu_op = `OP_ALU_SLTU;
                    // SLL
                    {7'b0000000, 3'b001}: o_alu_op = `OP_ALU_SLL;
                    // SRA
                    {7'b0100000, 3'b101}: o_alu_op = `OP_ALU_SRA;

                    // M-extension Instructions (MULTIPLY and DIVIDE)
                    // MUL
                    {7'b0000001, 3'b000}: o_alu_op = `OP_ALU_MUL;
                    // MULH
                    {7'b0000001, 3'b001}: o_alu_op = `OP_ALU_MULH;
                    // DIV
                    {7'b0000001, 3'b100}: o_alu_op = `OP_ALU_DIV;
                    // DIVU
                    {7'b0000001, 3'b101}: o_alu_op = `OP_ALU_DIVU;
                    // REM
                    {7'b0000001, 3'b110}: o_alu_op = `OP_ALU_REM;
                    // REMU
                    {7'b0000001, 3'b111}: o_alu_op = `OP_ALU_REMU;

                    default: o_alu_op = `OP_ALU_NOP;
                endcase
            end

            // I-type ALU Instructions
            7'b0010011: begin
                o_alu_src_a = 1'b0;  // ALU Source A is register
                o_alu_src_b = 1'b1;  // ALU Source B is immediate
                o_reg_write = 1'b1;  // Write to register
                case (i_inst[14:12])
                    3'b000: o_alu_op = `OP_ALU_ADD;  // ADDI
                    3'b110: o_alu_op = `OP_ALU_OR;   // ORI
                    3'b100: o_alu_op = `OP_ALU_XOR;  // XORI
                    default: o_alu_op = `OP_ALU_NOP;
                endcase
            end

            // Load Instructions (I-Type)
            7'b0000011: begin
                o_alu_src_a = 1'b0;  // ALU Source A is register
                o_alu_src_b = 1'b1;  // ALU Source B is immediate
                o_result_mux = 2'b10; // Result comes from memory
                o_reg_write = 1'b1;  // Write to register
                o_alu_op = `OP_ALU_ADD; // Address calculation (base + offset)
            end

            // Store Instructions (S-Type)
            7'b0100011: begin
                o_alu_src_a = 1'b0;  // ALU Source A is register
                o_alu_src_b = 1'b1;  // ALU Source B is immediate
                o_mem_write = 1'b1;  // Memory write enabled
                o_alu_op = `OP_ALU_ADD; // Address calculation (base + offset)
            end

            // Branch Instructions (B-Type)
            7'b1100011: begin
                o_branch = 1'b1; // Branching enabled
                o_alu_src_a = 1'b0; // ALU Source A is register
                o_alu_src_b = 1'b0; // ALU Source B is register
                case (i_inst[14:12])
                    3'b000: o_branch_op = `BRANCH_BEQ;  // BEQ
                    3'b001: o_branch_op = `BRANCH_BNE;  // BNE
                    3'b100: o_branch_op = `BRANCH_BLT;  // BLT
                    3'b101: o_branch_op = `BRANCH_BGE;  // BGE
                    3'b110: o_branch_op = `BRANCH_BLTU; // BLTU
                    3'b111: o_branch_op = `BRANCH_BGEU; // BGEU
                    default: o_branch_op = 3'b000;
                endcase
            end

            default: begin
                // No operation or unsupported opcode
                o_alu_op = `OP_ALU_NOP;
            end
        endcase
    end

endmodule

