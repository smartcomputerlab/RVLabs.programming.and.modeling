
//`timescale 1ns / 1ps

module Decoder(
    input wire [31:0] instruction,

    // ISA Opcodes
    output wire ALUReg,           // ALU operation based on register
    output wire ALUImmediate,     // ALU operation based on immediate
    output wire Branch,           // Branch based on immediate
    output wire JALR,             // Jump based on register
    output wire JAL,              // Jump based on immediate
    output wire AUIPC,            // Load value of PC + immediate into destination reg.
    output wire LUI,              // Stores immediate into register
    output wire Load,             // Loads memory at register + immediate into destination reg
    output wire Store,            // Stores value of register 2 into location register + immediate
    output wire System,           // System calls (ecall and ebreak)

    // Register addresses based on instruction
    output wire [4:0] SourceRegister1,     // rs1 in ISA
    output wire [4:0] SourceRegister2,     // rs2 in ISA
    output wire [4:0] DestinationRegister, // rd in ISA

    // ALU operation codes
    output wire [2:0] funct3,
    output wire [6:0] funct7,

    // Immediate values
    output wire [31:0] Iimm,      // Register-Immediate ALU
    output wire [31:0] Simm,      // Store Immediate
    output wire [31:0] Bimm,      // Branch Immediate
    output wire [31:0] Uimm,      // LUI/AUIPC Immediates
    output wire [31:0] Jimm       // Jump Immediates
);

    // Extract fields from the instruction
    wire [6:0] opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign SourceRegister1 = instruction[19:15];
    assign SourceRegister2 = instruction[24:20];
    assign DestinationRegister = instruction[11:7];

    // Decode opcodes for each type of instruction
    assign ALUReg = (opcode == 7'b0110011);       // R-type (e.g., ADD, SUB)
    assign ALUImmediate = (opcode == 7'b0010011);  // I-type ALU (e.g., ADDI, ORI)
    assign Branch = (opcode == 7'b1100011);        // B-type (e.g., BEQ, BNE)
    assign JALR = (opcode == 7'b1100111);          // I-type JALR
    assign JAL = (opcode == 7'b1101111);           // J-type JAL
    assign AUIPC = (opcode == 7'b0010111);         // U-type AUIPC
    assign LUI = (opcode == 7'b0110111);           // U-type LUI
    assign Load = (opcode == 7'b0000011);          // I-type Load (e.g., LW)
    assign Store = (opcode == 7'b0100011);         // S-type Store (e.g., SW)
    assign System = (opcode == 7'b1110011);        // System (e.g., ECALL, EBREAK)

    // Immediate generation for different types
    assign Iimm = {{20{instruction[31]}}, instruction[31:20]};            // I-type immediate (12-bit signed)
    assign Simm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type immediate (12-bit signed)
    assign Bimm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type immediate (13-bit signed)
    assign Uimm = {instruction[31:12], 12'b0};                            // U-type immediate (20-bit, upper 20 bits)
    assign Jimm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type immediate (21-bit signed)

endmodule

