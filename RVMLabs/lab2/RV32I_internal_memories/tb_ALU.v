`timescale 1ns / 1ps

module tb_ALU;

    // Inputs
    reg [31:0] instruction;
    reg [31:0] ALUVAL1;
    reg ALUReg;
    reg ALUImmediate;
    reg [31:0] ALUREGVAl2;
    reg [31:0] Iimm;
    reg [2:0] funct3;
    reg [6:0] funct7;

    // Output
    wire [31:0] ALUOut;

    // Instantiate the ALU
    ALU uut (
        .instruction(instruction),
        .ALUVAL1(ALUVAL1),
        .ALUReg(ALUReg),
        .ALUImmediate(ALUImmediate),
        .ALUREGVAl2(ALUREGVAl2),
        .Iimm(Iimm),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOut(ALUOut)
    );

    // Test cases
    initial begin
        // Initialize inputs
        ALUVAL1 = 32'h0000000F;   // Operand 1
        ALUREGVAl2 = 32'h00000003; // Operand 2
        Iimm = 32'h00000004;      // Immediate value

        // Test ADDI (Addition with Immediate)
        ALUReg = 0;
        ALUImmediate = 1;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        $display("ADDI: %h + %h = %h", ALUVAL1, Iimm, ALUOut);

        // Test ADD (Addition with Register)
        ALUReg = 1;
        ALUImmediate = 0;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        $display("ADD: %h + %h = %h", ALUVAL1, ALUREGVAl2, ALUOut);

        // Test SUB (Subtraction)
        funct7 = 7'b0100000;
        #10;
        $display("SUB: %h - %h = %h", ALUVAL1, ALUREGVAl2, ALUOut);

        // Test ANDI (AND with Immediate)
        ALUReg = 0;
        ALUImmediate = 1;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        $display("ANDI: %h & %h = %h", ALUVAL1, Iimm, ALUOut);

        // Test ORI (OR with Immediate)
        funct3 = 3'b110;
        #10;
        $display("ORI: %h | %h = %h", ALUVAL1, Iimm, ALUOut);

        // Test XORI (XOR with Immediate)
        funct3 = 3'b100;
        #10;
        $display("XORI: %h ^ %h = %h", ALUVAL1, Iimm, ALUOut);

        // Test SLLI (Shift Left Logical Immediate)
        funct3 = 3'b001;
        #10;
        $display("SLLI: %h << %h = %h", ALUVAL1, Iimm[4:0], ALUOut);

        // Test SRLI (Shift Right Logical Immediate)
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        $display("SRLI: %h >> %h = %h", ALUVAL1, Iimm[4:0], ALUOut);

        // Test SRAI (Shift Right Arithmetic Immediate)
        funct7 = 7'b0100000;
        #10;
        $display("SRAI: %h >>> %h = %h", ALUVAL1, Iimm[4:0], ALUOut);

        // Test SLT (Set Less Than, signed comparison)
        ALUReg = 1;
        ALUImmediate = 0;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        ALUVAL1 = 32'hFFFFFFFE;  // -2 in two's complement
        ALUREGVAl2 = 32'h00000001; // +1
        #10;
        $display("SLT: %h < %h = %h", ALUVAL1, ALUREGVAl2, ALUOut);

        // Test SLTU (Set Less Than Unsigned)
        funct3 = 3'b011;
        ALUVAL1 = 32'h00000001; // 1
        ALUREGVAl2 = 32'hFFFFFFFF; // Large unsigned value
        #10;
        $display("SLTU: %h < %h = %h", ALUVAL1, ALUREGVAl2, ALUOut);

        // End of test
        $finish;
    end

        initial begin
        $dumpfile("tb_ALU.vcd");  // Create the VCD file
        $dumpvars(0, tb_ALU);     // Dump variables
    end

endmodule

