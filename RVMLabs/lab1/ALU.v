module ALU(
    input [31:0] A,        // First 32-bit operand
    input [31:0] B,        // Second 32-bit operand
    input [3:0] ALUOp,     // 4-bit control signal to choose operation
    output reg [31:0] Result, // 32-bit output result
    output Zero            // Zero flag to indicate if result is zero
);

    always @(*) begin
        case (ALUOp)
            4'b0000: Result = A + B;         // Addition
            4'b0001: Result = A - B;         // Subtraction
            4'b0010: Result = A & B;         // Bitwise AND
            4'b0011: Result = A | B;         // Bitwise OR
            4'b0100: Result = A ^ B;         // Bitwise XOR
            4'b0101: Result = A << B[4:0];   // Logical shift left
            4'b0110: Result = A >> B[4:0];   // Logical shift right
            4'b0111: Result = $signed(A) >>> B[4:0]; // Arithmetic shift right
            default: Result = 32'b0;         // Default: Zero result
        endcase
    end

    // Zero flag: Set if result is zero
    assign Zero = (Result == 32'b0) ? 1'b1 : 1'b0;

endmodule

