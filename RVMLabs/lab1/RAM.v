module RAM (
    input clk,                    // Clock signal
    input we,                     // Write enable (1 for write, 0 for read)
    input [7:0] addr,             // 8-bit address (for 256 words)
    input [31:0] data_in,         // 32-bit input data for writing
    output reg [31:0] data_out    // 32-bit output data for reading
);

    // Declare the RAM memory (256 words of 32-bit data)
    reg [31:0] memory [255:0];

    // Read/Write logic
    always @(posedge clk) begin
        if (we) begin
            // Write operation: If write enable is high, store data_in at addr
            memory[addr] <= data_in;
        end else begin
            // Read operation: If write enable is low, output data from addr
            data_out <= memory[addr];
        end
    end

endmodule

