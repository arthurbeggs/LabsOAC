module LCD_Interface(
	input iCLK,
	input iCLK_50,
	input Reset,
	inout	[7:0]	LCD_D,			//	LCD Data bus 8 bits
	output oLCD_ON,		//	LCD Power ON/OFF
	output oLCD_BLON,		//	LCD Back Light ON/OFF
	output oLCD_RW,		//	LCD Read/Write Select, 0 = Write, 1 = Read
	output oLCD_EN,		//	LCD Enable
	output oLCD_RS,		//	LCD Command/Data Select, 0 = Command, 1 = Data
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData,
	
	//  Debug
	input wDebug,
	input [31:0] wPC,
	input [31:0] wInstr
);


assign	oLCD_ON		=	1'b1;
assign	oLCD_BLON	=	1'b1;

wire [7:0] oLeituraLCD;
	
LCDStateMachine LCDSM0 (
	.iCLK(iCLK_50),
	.iRST(Reset),
	.LCD_DATA(LCD_D),
	.LCD_RW(oLCD_RW),
	.LCD_EN(oLCD_EN),
	.LCD_RS(oLCD_RS),
	.iMemAddress(wAddress),
	.iMemWriteData(wWriteData),
	.iMemWrite(wWriteEnable),
	.oLeitura(oLeituraLCD),
	.wPC(wPC),
	.wInstr(wInstr),
	.wDebug(wDebug)
	);
	
	
	always @(*)
		if(wReadEnable)
			if(wAddress>=BEGINNING_LCD && wAddress <= END_LCD)  wReadData <= {24'b0,oLeituraLCD};
			else wReadData <= 32'hzzzzzzzz;
		else wReadData <= 32'hzzzzzzzz;
	
	
endmodule
