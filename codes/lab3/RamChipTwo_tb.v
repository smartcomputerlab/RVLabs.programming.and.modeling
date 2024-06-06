module RamChipTwo_tb ();
reg clk_tb =0;
reg[3:0] read_addr_tb, write_addr_tb;
wire[7:0] out_data_tb;
reg[7:0] in_data_tb;
reg we_tb;

defparam mem0.AddressSize=4;
defparam mem0.WordSize=8;
RamChipTwo mem0(read_addr_tb,write_addr_tb,in_data_tb,out_data_tb,clk_tb,we_tb);

initial begin

	$dumpfile("RamChipTwo_wave.vcd");
	$dumpvars;
	write_addr_tb = 4'b0000;
	write_addr_tb = 4'b0000;
	#2 we_tb =1; in_data_tb=8'b11100011;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 write_addr_tb =4'b0001;
	#2 we_tb =1; in_data_tb=8'b10101010;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 we_tb=0;
	#2 read_addr_tb = 4'b0001;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 write_addr_tb = 4'b0010;
	#2 we_tb =1; in_data_tb=8'b11001100;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 we_tb=0;
	#2 read_addr_tb = 4'b0010;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 write_addr_tb = 4'b0011;
	#2 we_tb =1; in_data_tb=8'b1110110;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#2 we_tb=0;
	#2 read_addr_tb = 4'b0011;
	#2 $display("write_data=%b, read_data=%b",in_data_tb,out_data_tb);
	#100 $finish;
end

always #1 clk_tb =!clk_tb;
endmodule
