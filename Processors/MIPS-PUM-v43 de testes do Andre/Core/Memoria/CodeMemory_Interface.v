
module CodeMemory_Interface (
	input iCLK, iCLKMem, 		
	//  Barramento de IO
	input tri wReadEnable, wWriteEnable,
	input tri [3:0] wByteEnable,
	input tri [31:0] wAddress, wWriteData,
	output tri [31:0] wReadData
);


BootBlock BB0 (
	.address(wAddress[8:2]),
	.clock(iCLKMem),
	.q(wMemDataBB0)
	);
	
UserCodeBlock MB0 (
	.address(wAddress[13:2]),
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWriteMB0),
	.q(wMemDataMB0)
	);

SysCodeBlock MB1 (
	.address(wAddress[12:2]),
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWriteMB1),
	.q(wMemDataMB1)
	);
 
 
 	reg MemWritten;
	initial MemWritten <= 1'b0;
	always @(iCLKMem) MemWritten <= iCLKMem;


	wire wMemWriteMB0, wMemWriteMB1;
	wire [31:0] wMemDataMB0, wMemDataMB1, wMemDataBB0;
	wire is_sysmem, is_usermem, is_boot;

	assign is_usermem = 	wAddress>=BEGINNING_TEXT 	&& wAddress<=END_TEXT;		// Programa usuario .text
	assign is_sysmem 	= 	wAddress>=BEGINNING_KTEXT 	&& wAddress<=END_KTEXT;		// Programa sistema .ktext
	assign is_boot		= 	wAddress>=BEGINNING_BOOT 	&& wAddress<=END_BOOT;      		// Memoria de Boot

	assign wMemWriteMB0 = ~MemWritten && wWriteEnable && is_usermem;
	assign wMemWriteMB1 = ~MemWritten && wWriteEnable && is_sysmem;

	always @(*)
		if(wReadEnable)
			begin
				if(is_sysmem)  	wReadData <= wMemDataMB1; else
				if(is_usermem)		wReadData <= wMemDataMB0; else
				if(is_boot)			wReadData <= wMemDataBB0; else
				wReadData <= 32'hzzzzzzzz;
			end
		else
			wReadData <= 32'hzzzzzzzz;
									
									
		



endmodule

 