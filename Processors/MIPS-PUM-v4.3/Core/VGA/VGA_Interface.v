/*
 * VGAAdapterInterface
 *
 * CPU interface module to the VGA Adapter.
 */
module VGA_Interface (
	input iRST, iCLK_50, CLK,
	output oVGA_CLOCK, oVGA_HS, oVGA_VS, oVGA_BLANK_N, oVGA_SYNC_N,
	output [9:0] oVGA_R, oVGA_G, oVGA_B,
	output reg [4:0] oVGASelect,
	input wire [31:0] iVGARead,
	input wire iDebugEnable,
	
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData
	);

wire [31:0] wReadVGA;

VgaAdapter VGA0(
	.resetn(~iRST),
	.iCLK(CLK),
	.CLOCK_50(iCLK_50),
	.color_in(wWriteData),
	.color_out(wReadVGA),
	.address(wAddress),
	.iMemWrite(wWriteEnable),
	.VGA_R(oVGA_R),
	.VGA_G(oVGA_G),
	.VGA_B(oVGA_B),
	.VGA_HS(oVGA_HS),
	.VGA_VS(oVGA_VS),
	.VGA_BLANK(oVGA_BLANK_N),
	.VGA_SYNC(oVGA_SYNC_N),
	.VGA_CLK(oVGA_CLOCK),
	.iByteEnable(wByteEnable),
	.oVGASelect(oVGASelect),
	.iVGARead(iVGARead),
	.iDebugEnable(iDebugEnable)
);


always @(*)
		if(wReadEnable)
			if(wAddress>=BEGINNING_VGA && wAddress <= END_VGA) wReadData <= wReadVGA;
			else wReadData <= 32'hzzzzzzzz;
		else wReadData <= 32'hzzzzzzzz;

endmodule
