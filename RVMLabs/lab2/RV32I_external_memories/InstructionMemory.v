module InstructionMemory (
    input [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] memory [0:255]; // Define instruction memory with 256 entries

    initial begin
        // Load instructions into memory for testing
	$readmemh("instructions.hex", memory);
    end

    // Fetch instruction
    assign instruction = memory[addr[9:2]]; // Addressing in word-aligned format
endmodule

