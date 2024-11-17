module InstructionMemory (
    input [31:0] addr,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255]; // Define instruction memory with 256 entries

    initial begin
        // Load instructions into memory for testing
        memory[0] = 32'h00500113; // ADDI x2, x0, 5
        memory[1] = 32'h00410193; // ADDI x3, x2, 4
        memory[2] = 32'h00218233; // ADD x4, x3, x2
        memory[3] = 32'hFFF10113; // ADDI x2, x2, -1
    end

    // Fetch instruction
    assign instruction = memory[addr[9:2]]; // Addressing in word-aligned format
endmodule

