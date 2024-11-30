module DATAPATH (
    input clk,
    input reset,
    input reg_write,
    input alu_src,
    input [3:0] alu_control,
    input [31:0] instruction,
    output zero
);

    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd = instruction[11:7];
    wire [31:0] imm = {{20{instruction[31]}}, instruction[31:20]}; // Sign-extended immediate

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] alu_input_b;
    wire [31:0] alu_result;

    REG_FILE reg_file (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(alu_result),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    assign alu_input_b = alu_src ? imm : read_data2;

    ALU alu (
        .a(read_data1),
        .b(alu_input_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );
endmodule

