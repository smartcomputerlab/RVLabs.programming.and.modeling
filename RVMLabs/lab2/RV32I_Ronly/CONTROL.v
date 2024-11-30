module CONTROL (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg reg_write,
    output reg alu_src,
    output reg [3:0] alu_control
);

    always @(*) begin
        reg_write = 1;
        alu_src = (opcode == 7'b0010011); // I-type uses immediate, R-type does not

        case (opcode)
            7'b0110011: begin // R-type
                case ({funct7, funct3})
                    10'b0000000000: alu_control = 4'b0000; // ADD
                    10'b0100000000: alu_control = 4'b0001; // SUB
                    10'b0000000111: alu_control = 4'b0010; // AND
                    10'b0000000110: alu_control = 4'b0011; // OR
                    10'b0000000100: alu_control = 4'b0100; // XOR
                    10'b0000000001: alu_control = 4'b0101; // SLL
                    10'b0000000101: alu_control = 4'b0110; // SRL
                    10'b0100000101: alu_control = 4'b0111; // SRA
                    default: alu_control = 4'b0000;
                endcase
            end
            7'b0010011: begin // I-type
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b111: alu_control = 4'b0010; // ANDI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b001: alu_control = 4'b0101; // SLLI
                    3'b101: alu_control = (funct7[5] ? 4'b0111 : 4'b0110); // SRAI or SRLI
                    default: alu_control = 4'b0000;
                endcase
            end
            default: begin
                reg_write = 0;
                alu_control = 4'b0000;
            end
        endcase
    end
endmodule

