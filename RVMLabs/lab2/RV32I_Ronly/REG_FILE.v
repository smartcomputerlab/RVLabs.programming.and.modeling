module REG_FILE (
    input clk,
    input reg_write,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] regfile [31:0];

    // Read registers
    assign read_data1 = regfile[rs1];
    assign read_data2 = regfile[rs2];

    // Write to register
    always @(posedge clk) begin
        if (reg_write && rd != 0)
            regfile[rd] <= write_data;  // Write only if reg_write is high and rd is non-zero
    end
endmodule

