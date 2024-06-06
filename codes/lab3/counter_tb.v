module counter_tb;
/* Make a reset that pulses once. */
reg reset = 0;
initial begin
$dumpfile("counter_wave.vcd"); // trace file
$dumpvars;
// variables to dumb - all
# 17 reset = 1;
// reset sequence
# 11 reset = 0;
# 29 reset = 1;
# 5 reset =0;
# 513 $finish;
// end of simulation run
end
reg clk = 0;
always #1 clk =!clk;
// continuous process : clock wave
wire [7:0] value;
// the value of counter
counter c1 (value, clk, reset);
// here we instantiate the counter
initial
$monitor("At time %t,value =%h (%0d)",$time,value,value);
endmodule // counter_tb
