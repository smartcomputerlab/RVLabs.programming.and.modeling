module INST_MEM (
    input [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];  // Define 256 x 32-bit memory for instructions

    assign instruction = memory[addr[9:2]];  // Fetch instruction based on address
endmodule

