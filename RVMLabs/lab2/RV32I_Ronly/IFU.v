module IFU (
    input clk,
    input reset,
    output reg [31:0] pc,
    output [31:0] instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else
            pc <= pc + 4;  // Increment by 4 for the next instruction
    end
endmodule

