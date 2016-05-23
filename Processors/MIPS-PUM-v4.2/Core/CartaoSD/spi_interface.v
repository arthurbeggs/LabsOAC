module my_spi_interface(readdata,writedata,write,clock,reset_n,SD_CLK,SD_MOSI,SD_MISO,SD_CS);
output [7:0] readdata;
input [7:0] writedata;
input write;
input clock;
input reset_n;
output SD_CLK;
output SD_MOSI;
input SD_MISO;
output SD_CS;


reg [3:0] ff;
wire enable;
/*
assign enable = (chip_select && write);
assign readdata[0] = ff[0];
assign readdata[1] = ff[1];
assign readdata[2] = ff[2];
assign readdata[3] = ff[3];
assign readdata[31:4] = 28'b0;

assign SD_CLK = ff[0];
assign SD_MOSI = ff[1];
assign SD_CS = ff[3];
always@(posedge clock)
begin
	if(enable)
	begin
		if(reset_n)
		begin
			ff[0] <= writedata[0];
			ff[1] <= writedata[1];
			ff[2] <= SD_MISO;
			ff[3] <= writedata[3];
		end
		else
		begin
			ff[0] <= 1'b0;
			ff[1] <= 1'b0;
			ff[2] <= 1'b0;
			ff[3] <= 1'b0;
		end 
	end
end
*/
 sd_controller sd1(
	.cs(SD_CS),
	.mosi(SD_MOSI),
	.miso(SD_MISO),
	.sclk(SD_CLK),

	.rd(~write),
	.wr(write),
	.dm_in(1),	// data mode, 0 = write continuously, 1 = write single block
	.reset(~reset_n),
	.din(writedata[7:0]),
	.dout(readdata[7:0]),
	.clk(clock)
);

endmodule