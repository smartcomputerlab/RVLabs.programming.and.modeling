module ALU (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);

    assign zero = (result == 0);

    always @(*) begin
        case (alu_control)
            4'b0000: result = a + b;           // ADD
            4'b0001: result = a - b;           // SUB
            4'b0010: result = a & b;           // AND
            4'b0011: result = a | b;           // OR
            4'b0100: result = a ^ b;           // XOR
            4'b0101: result = a << b[4:0];     // SLL (shift left logical)
            4'b0110: result = a >> b[4:0];     // SRL (shift right logical)
            4'b0111: result = $signed(a) >>> b[4:0]; // SRA (shift right arithmetic)
            default: result = 32'd0;           // Default case
        endcase
    end
endmodule

