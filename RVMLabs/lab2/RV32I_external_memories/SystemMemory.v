module SystemMemory (
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire MemRead,
    input wire MemWrite,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:255]; // Define data memory with 256 entries

    // Write operation (synchronous)
    always @(posedge clk) begin
        if (MemWrite) begin
            memory[addr[9:2]] <= write_data; // Write to memory if MemWrite is high
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (MemRead) begin
            read_data = memory[addr[9:2]]; // Read from memory if MemRead is high
        end else begin
            read_data = 32'b0;
        end
    end
endmodule

