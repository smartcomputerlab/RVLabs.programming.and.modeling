module tb_ALU; // Testbench module
    reg [31:0] A, B;
    reg [3:0] ALUOp;
    wire [31:0] Result;
    wire Zero;
    // Instantiate the ALU
    ALU uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin
        // Test addition
        A = 32'h00000005; B = 32'h00000003; ALUOp = 4'b0000;
        #10;
        $display("Addition: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test subtraction
        A = 32'h00000005; B = 32'h00000005; ALUOp = 4'b0001;
        #10;
        $display("Subtraction: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test AND
        A = 32'h0000000F; B = 32'h000000F0; ALUOp = 4'b0010;
        #10;
        $display("AND: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test OR
        A = 32'h0000000F; B = 32'h000000F0; ALUOp = 4'b0011;
        #10;
        $display("OR: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test XOR
        A = 32'h0000000F; B = 32'h000000F0; ALUOp = 4'b0100;
        #10;
        $display("XOR: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test shift left
        A = 32'h00000001; B = 32'h00000004; ALUOp = 4'b0101;
        #10;
        $display("Shift Left: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test shift right
        A = 32'h00000010; B = 32'h00000002; ALUOp = 4'b0110;
        #10;
        $display("Shift Right: A = %h, B = %h, Result = %h, Zero = %b", A, B, Result, Zero);
        // Test arithmetic shift right
        A = 32'h80000000; B = 32'h00000002; ALUOp = 4'b0111;
        #10;
        $display("Arithmetic Shift Right:A = %h,B = %h,Result = %h,Zero = %b",A,B,Result,Zero);
        $finish;
    end
        // Dumping the waveform for GTKWave
    initial begin
        $dumpfile("tb_ALU.vcd");  // Create the VCD 
        $dumpvars(0, tb_ALU);     // Dump variables
    end
endmodule

