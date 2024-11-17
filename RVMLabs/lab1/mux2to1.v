module mux2to1 (
    input wire a,      // Input A
    input wire b,      // Input B
    input wire sel,    // Select line
    output wire y      // Output Y
);
assign y = (sel) ? b : a;   // If sel = 1, choose B; otherwise, choose A
endmodule

