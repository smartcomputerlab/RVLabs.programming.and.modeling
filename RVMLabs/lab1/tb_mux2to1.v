module tb_mux2to1;
    reg a, b, sel;
    wire y;

    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    initial begin
        // Test case 1: sel = 0, a = 0, b = 1
        a = 0; b = 1; sel = 0;
        #10; // Wait 10 time units
        $display("Test 1: y = %b", y);  // Should print y = 0
        // Test case 2: sel = 1, a = 0, b = 1
        sel = 1;
        #10;
        $display("Test 2: y = %b", y);  // Should print y = 1
        $finish; // End simulation
    end
endmodule

