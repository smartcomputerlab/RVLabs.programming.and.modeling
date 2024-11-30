module INST_MEM (
    input [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];  // Define 256 x 32-bit memory for instructions

    initial begin
        // Sample R-type and I-type instructions in memory

        // R-type (ADD x1, x2, x3): x1 = x2 + x3
        memory[0] = 32'b0000000_00011_00010_000_00001_0110011;

        // I-type (ADDI x4, x1, 10): x4 = x1 + 10
        memory[1] = 32'b000000000101_00001_000_00100_0010011;

        // R-type (SUB x5, x4, x1): x5 = x4 - x1
        memory[2] = 32'b0100000_00001_00100_000_00101_0110011;

        // I-type (ORI x6, x5, 15): x6 = x5 | 15
        memory[3] = 32'b0000000001111_00101_110_00110_0010011;

        // R-type (SLL x7, x6, x4): x7 = x6 << x4
        memory[4] = 32'b0000000_00100_00110_001_00111_0110011;

        // I-type (SRLI x8, x7, 2): x8 = x7 >> 2
        memory[5] = 32'b000000000010_00111_101_01000_0010011;

        // Add more instructions as needed for testing

        // Fill remaining memory with NOP (no operation) instructions
        // NOP in RISC-V is equivalent to ADDI x0, x0, 0
        for (integer i = 6; i < 256; i = i + 1) begin
            memory[i] = 32'b000000000000_00000_000_00000_0010011;
        end
    end

    assign instruction = memory[addr[9:2]];  // Fetch instruction based on address
endmodule

