module RamChipTwo(read_addr,write_addr,in_data,out_data,CLK,WE);
parameter AddressSize=1;
parameter WordSize=1;
input [AddressSize-1:0]read_addr,write_addr;
input [WordSize-1:0]in_data;
output reg [WordSize-1:0]out_data;
input CLK,WE;
// Declare the RAM variable
reg [WordSize-1:0] Mem[0:(1<<AddressSize)-1];
always @ (posedge CLK)
begin
// Write
if (WE)
Mem[write_addr] <= in_data;
out_data <= Mem[read_addr];
end
endmodule
