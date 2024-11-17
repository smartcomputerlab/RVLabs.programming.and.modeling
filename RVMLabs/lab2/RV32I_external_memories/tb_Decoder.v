`timescale 1ns / 1ps

module tb_Decoder;

    // Inputs
    reg [31:0] instruction;

    // Outputs
    wire ALUReg;
    wire ALUImmediate;
    wire Branch;
    wire JALR;
    wire JAL;
    wire AUIPC;
    wire LUI;
    wire Load;
    wire Store;
    wire System;

    wire [4:0] SourceRegister1;
    wire [4:0] SourceRegister2;
    wire [4:0] DestinationRegister;

    wire [2:0] funct3;
    wire [6:0] funct7;

    wire [31:0] Iimm;
    wire [31:0] Simm;
    wire [31:0] Bimm;
    wire [31:0] Uimm;
    wire [31:0] Jimm;

    // Instantiate the Decoder
    Decoder uut (
        .instruction(instruction),
        .ALUReg(ALUReg),
        .ALUImmediate(ALUImmediate),
        .Branch(Branch),
        .JALR(JALR),
        .JAL(JAL),
        .AUIPC(AUIPC),
        .LUI(LUI),
        .Load(Load),
        .Store(Store),
        .System(System),
        .SourceRegister1(SourceRegister1),
        .SourceRegister2(SourceRegister2),
        .DestinationRegister(DestinationRegister),
        .funct3(funct3),
        .funct7(funct7),
        .Iimm(Iimm),
        .Simm(Simm),
        .Bimm(Bimm),
        .Uimm(Uimm),
        .Jimm(Jimm)
    );

    // Test cases
    initial begin
        // Test I-type (ADDI)
        instruction = 32'b000000000100_00001_000_00010_0010011; // ADDI x2, x1, 4
        #10;
        $display("ADDI Instruction: ALUImmediate=%b, Iimm=%h", ALUImmediate, Iimm);

        // Test R-type (ADD)
        instruction = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3, x1, x2
        #10;
        $display("ADD Instruction: ALUReg=%b, SourceRegister1=%d, SourceRegister2=%d, DestinationRegister=%d, funct3=%b, funct7=%b",
                 ALUReg, SourceRegister1, SourceRegister2, DestinationRegister, funct3, funct7);

        // Test B-type (BEQ)
        instruction = 32'b0000000_00010_00001_000_000000000110_1100011; // BEQ x1, x2, offset 6
        #10;
        $display("BEQ Instruction: Branch=%b, Bimm=%h", Branch, Bimm);

        // Test U-type (LUI)
        instruction = 32'b00000000000000000001_00000_0110111; // LUI x0, 0x1
        #10;
        $display("LUI Instruction: LUI=%b, Uimm=%h", LUI, Uimm);

        // Test U-type (AUIPC)
        instruction = 32'b00000000000000000010_00001_0010111; // AUIPC x1, 0x2
        #10;
        $display("AUIPC Instruction: AUIPC=%b, Uimm=%h", AUIPC, Uimm);

        // Test J-type (JAL)
        instruction = 32'b00000000000100000000_00001_1101111; // JAL x1, offset 0x100
        #10;
        $display("JAL Instruction: JAL=%b, Jimm=%h", JAL, Jimm);

        // Test I-type (JALR)
        instruction = 32'b000000000100_00001_000_00010_1100111; // JALR x2, x1, 4
        #10;
        $display("JALR Instruction: JALR=%b, Iimm=%h", JALR, Iimm);

        // Test Load (LW)
        instruction = 32'b000000000100_00001_010_00010_0000011; // LW x2, 4(x1)
        #10;
        $display("Load Instruction: Load=%b, Iimm=%h", Load, Iimm);

        // Test Store (SW)
        instruction = 32'b0000000_00010_00001_010_000000001000_0100011; // SW x2, 8(x1)
        #10;
        $display("Store Instruction: Store=%b, Simm=%h", Store, Simm);

        // Test System (ECALL)
        instruction = 32'b00000000000000000000000001110011; // ECALL
        #10;
        $display("System Instruction: System=%b", System);

        // End of test
        $finish;
    end

        // Monitor outputs for debugging
    initial begin
        $dumpfile("tb_Decoder.vcd");  // Create the VCD file
        $dumpvars(0, tb_Decoder);     // Dump variables
    end

endmodule

