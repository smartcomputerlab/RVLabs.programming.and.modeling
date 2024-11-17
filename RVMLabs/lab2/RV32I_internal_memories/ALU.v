module ALU (
    input wire [31:0] instruction,
    input wire [31:0] ALUVAL1,           // Register Source 1
    input wire ALUReg,                   // Control signal to select register source 2
    input wire ALUImmediate,             // Control signal to select immediate
    input wire [31:0] ALUREGVAl2,        // Value from register source 2
    input wire [31:0] Iimm,              // Immediate value
    input wire [2:0] funct3,             // Function code (3 bits)
    input wire [6:0] funct7,             // Function code (7 bits)
    output reg [31:0] ALUOut             // ALU output to the destination register
);

    wire [31:0] ALUOperand2;

    // Select the second operand based on control signals
    assign ALUOperand2 = (ALUReg) ? ALUREGVAl2 : 
                         (ALUImmediate) ? Iimm : 
                         32'b0;

    always @(*) begin
        case (funct3)
            3'b000: begin
                // ADD or SUB
                if (funct7 == 7'b0100000)  // SUB (funct7 = 0x20)
                    ALUOut = ALUVAL1 - ALUOperand2;
                else                       // ADD (funct7 = 0x00)
                    ALUOut = ALUVAL1 + ALUOperand2;
            end

            3'b001: begin
                // SLL (Shift Left Logical)
                ALUOut = ALUVAL1 << ALUOperand2[4:0];
            end

            3'b010: begin
                // SLT (Set Less Than)
                ALUOut = ($signed(ALUVAL1) < $signed(ALUOperand2)) ? 32'b1 : 32'b0;
            end

            3'b011: begin
                // SLTU (Set Less Than Unsigned)
                ALUOut = (ALUVAL1 < ALUOperand2) ? 32'b1 : 32'b0;
            end

            3'b100: begin
                // XOR
                ALUOut = ALUVAL1 ^ ALUOperand2;
            end

            3'b101: begin
                // SRL or SRA (Shift Right Logical/Arithmetic)
                if (funct7 == 7'b0100000)  // SRA (Arithmetic shift right)
                    ALUOut = $signed(ALUVAL1) >>> ALUOperand2[4:0];
                else                       // SRL (Logical shift right)
                    ALUOut = ALUVAL1 >> ALUOperand2[4:0];
            end

            3'b110: begin
                // OR
                ALUOut = ALUVAL1 | ALUOperand2;
            end

            3'b111: begin
                // AND
                ALUOut = ALUVAL1 & ALUOperand2;
            end

            default: begin
                // Default case, output zero
                ALUOut = 32'b0;
            end
        endcase
    end
endmodule

