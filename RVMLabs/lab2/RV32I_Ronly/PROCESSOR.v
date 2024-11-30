module PROCESSOR (
    input clk,
    input reset
);

    wire [31:0] pc;
    wire [31:0] instruction;
    wire reg_write;
    wire alu_src;
    wire [3:0] alu_control;
    wire zero;

    IFU ifu (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    INST_MEM inst_mem (
        .addr(pc),
        .instruction(instruction)
    );

    CONTROL control (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_control(alu_control)
    );

    DATAPATH datapath (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_control(alu_control),
        .instruction(instruction),
        .zero(zero)
    );
endmodule

