module tb_RAM;

    reg clk;                // Clock signal
    reg we;                 // Write enable signal
    reg [7:0] addr;         // 8-bit address for memory
    reg [31:0] data_in;     // 32-bit input data for write
    wire [31:0] data_out;   // 32-bit output data for read
    // Instantiate the RAM module
    RAM uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );
    // Clock generator: Toggle clk every 5 time units
    always #5 clk = ~clk;
    initial begin
        // Initialize signals
        clk = 0;
        we = 0;
        addr = 0;
        data_in = 0;
        // Write data to address 0
        #10;
        we = 1;
        addr = 8'h00;       // Address 0
        data_in = 32'hDEADBEEF; // Data to write
        #10;
        // Write data to address 1
        we = 1;
        addr = 8'h01;       // Address 1
        data_in = 32'hCAFEBABE; // Data to write
        #10;
        // Read data from address 0
        we = 0;
        addr = 8'h00;       // Address 0
        #10;
        $display("Read Address 0: Data = %h", data_out);
        // Read data from address 1
        we = 0;
        addr = 8'h01;       // Address 1
        #10;
        $display("Read Address 1: Data = %h", data_out);
        // Finish simulation
        $finish;
    end

    initial begin
        $dumpfile("tb_RAM.vcd");  // Create the VCD file
        $dumpvars(0, tb_RAM);     // Dump variables
    end

endmodule

