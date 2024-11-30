`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns


module data_memory #(
    parameter MEM_SIZE = 1024
) (
    input wire i_clk,
    input wire i_we,
    input wire [`DATA_WIDTH-1:0] i_data,
    input wire [$clog2(MEM_SIZE)-1:0] i_addr,
    output wire [`DATA_WIDTH-1:0] o_data
);

    reg [`DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            memory[i] = 0;  // Initialize each memory location to 0
        end
    end

    always @(posedge i_clk) begin
        if (i_we) begin
            memory[i_addr >> 2] <= i_data;
        end
    end
    assign o_data = memory[i_addr >> 2];

endmodule

