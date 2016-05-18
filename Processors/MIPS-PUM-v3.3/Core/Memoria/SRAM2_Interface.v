module SRAM2_Interface (
	input iCLK,
	input  iCLKMem, // usar pelo menos 4xiCLK
	inout [31:0] SRAM_DQ, 	// SRAM Data Bus 32 Bits
	output [18:0] oSRAM_A, 	// SRAM Address bus 21 Bits
	output oSRAM_ADSC_N, 	// SRAM Controller Address Status 
	output oSRAM_ADSP_N, 	// SRAM Processor Address Status
	output oSRAM_ADV_N, 		// SRAM Burst Address Advance
	output [3:0] oSRAM_BE_N, // SRAM Byte Write Enable
	output oSRAM_CE1_N, 		// SRAM Chip Enable
	output oSRAM_CE2, 		// SRAM Chip Enable
	output oSRAM_CE3_N, 		// SRAM Chip Enable
	output oSRAM_CLK, 		// SRAM Clock
	output oSRAM_GW_N, 		// SRAM Global Write Enable
	output oSRAM_OE_N, 		// SRAM Output Enable
	output oSRAM_WE_N, 		// SRAM Write Enable
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData,
	//  Barramento de DMA para o Sintetizador, read only
	input wReadEnableS,
	input [31:0] wAddressS,
	output [31:0] wReadDataS	
	);
	
	initial
		begin
			clkP<=0;
			clkS<=0;
		end
			
	reg clkP, clkS;
	
	always @(posedge iCLKMem)
		clkP=~clkP; //iCLKmem/2
	
	always @(posedge clkP)
		clkS=~clkS; //iCLKmem/4
	
//	reg MemWritten;
//	initial MemWritten <= 1'b0;
//	always @(iCLKMem) MemWritten <= iCLKMem;

	wire [31:0] wSRAMReadData;
	
	wire wSRAMWrite = clkS && (wAddress >= BEGINNING_SRAM) && (wAddress <= END_SRAM && wWriteEnable);// && ~MemWritten);
	
	assign oSRAM_A 		= (clkS? wAddress[20:2] : wAddressS[20:2]);
	assign oSRAM_BE_N 	= ~wByteEnable; //byteena=1111->oSRAM_BE_N=0000
	assign oSRAM_CE1_N 	= 1'b0;
	assign oSRAM_CE2 		= 1'b1;
	assign oSRAM_CE3_N 	= 1'b0;
	assign oSRAM_ADV_N 	= 1'b1;
	assign oSRAM_ADSC_N 	= 1'b1;
	assign oSRAM_ADSP_N 	= wSRAMWrite;
	assign oSRAM_WE_N 	= (~wSRAMWrite);
	assign oSRAM_GW_N 	= 1'b1;
	assign oSRAM_OE_N 	= 1'b0;
	assign oSRAM_CLK 		= iCLKMem;
	// If write is disabled, then float bus, so that SRAM can drive it (READ)
	// If write is enables, drive it with data from input to be stored in SRAM (WRITE)
	assign SRAM_DQ 		= (wSRAMWrite ? wWriteData : 32'hzzzzzzzz);
	assign wSRAMReadData = SRAM_DQ;
	
	reg [31:0] BwReadData, BwReadDataS; // buffers de saida da memoria
	initial
		begin
			BwReadData=32'b0;
			BwReadDataS=32'b0;
		end
		
	always @(negedge clkS)
		BwReadData <= wSRAMReadData;
		
	always @(posedge clkS)
		BwReadDataS <= wSRAMReadData;
	
	always @(*)
	begin
		if(wReadEnable)  //Leitura
			if(wAddress >= BEGINNING_SRAM && wAddress <= END_SRAM)	wReadData <= BwReadData; 
			else wReadData <= 32'hzzzzzzzz;
		else
			wReadData <= 32'hzzzzzzzz;

		if(wReadEnableS)  //Leitura para o Sintetizador
			if(wAddressS >= BEGINNING_SRAM && wAddressS <= END_SRAM)	wReadDataS <= BwReadDataS; 
			else wReadDataS <= 32'hzzzzzzzz;
		else
			wReadDataS <= 32'hzzzzzzzz;	
	end
	
endmodule
