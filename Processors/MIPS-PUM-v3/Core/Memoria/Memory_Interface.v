
module Memory_Interface (
	input iCLK, iCLKMem, 		
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData	
);

	

BootBlock BB0 (
	.address(wAddress[8:2]),  // em words
	.clock(iCLKMem),
	.q(wMemData_Boot)
	);
																		
UserCodeBlock UCodeMem (
	.address(wAddress[13:2]),			//em words
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWrite_UserCode),
	.q(wMemData_UserCode)
);
																	
UserDataBlock UDataMem (
	.address(wAddress[12:2]),		//em Words!!
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWrite_UserData),
	.q(wMemData_UserData)
);

SysCodeBlock SCodeMem (
	.address(wAddress[12:2]),			//em words
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWrite_SystemCode),
	.q(wMemData_SystemCode)
);

SysDataBlock SDataMem (
	.address(wAddress[11:2]),		//em Words!!
	.byteena(wByteEnable),
	.clock(iCLKMem),
	.data(wWriteData),
	.wren(wMemWrite_SystemData),
	.q(wMemData_SystemData)
	);


	
	reg MemWritten=1'b0;
//	initial MemWritten <= 1'b0;
//	always @(iCLKMem) MemWritten <= iCLKMem;
	
	
	wire wMemWrite_UserCode, wMemWrite_UserData, wMemWrite_SystemCode, wMemWrite_SystemData;
	wire [31:0] wMemData_UserCode, wMemData_UserData, wMemData_SystemCode, wMemData_SystemData, wMemData_Boot;
	wire is_usercode, is_userdata, is_systemcode, is_systemdata, is_boot;

	assign is_usercode 		= wAddress>=BEGINNING_TEXT		&& wAddress<=END_TEXT;
	assign is_userdata 		= wAddress>=BEGINNING_DATA		&& wAddress<=END_DATA;
	assign is_systemcode		= wAddress>=BEGINNING_KTEXT	&& wAddress<=END_KTEXT;
	assign is_systemdata 	= wAddress>=BEGINNING_KDATA	&& wAddress<=END_KDATA;
	assign is_boot 			= wAddress>=BEGINNING_BOOT 	&& wAddress<=END_BOOT;

	assign wMemWrite_UserCode 		= ~MemWritten && wWriteEnable && is_usercode;
	assign wMemWrite_UserData 		= ~MemWritten && wWriteEnable && is_userdata;
	assign wMemWrite_SystemCode	= ~MemWritten && wWriteEnable && is_systemcode;
	assign wMemWrite_SystemData	= ~MemWritten && wWriteEnable && is_systemdata;

	always @(*)
	if(wReadEnable)
		begin
			if(is_usercode)  	wReadData <= wMemData_UserCode; else
			if(is_userdata)	wReadData <= wMemData_UserData; else
			if(is_systemcode)	wReadData <= wMemData_SystemCode; else
			if(is_systemdata)	wReadData <= wMemData_SystemData; else
			if(is_boot)			wReadData <= wMemData_Boot; else
			wReadData <= 32'hzzzzzzzz;
		end
	else
		wReadData <= 32'hzzzzzzzz;
			
endmodule
