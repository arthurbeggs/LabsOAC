/* Definicao do processador */


module CPU (
	input wire	iCLK, iCLK50, iRST,
	input wire [31:0] iInitialPC,
	//sinais de monitoramento
	output wire [31:0] wRegDisp, wRegDispFPU, wRegDispCOP0,
	input wire [4:0] wRegDispSelect,
	output wire [31:0] wDebug,
	output wire [7:0] flagBank,
	output wire [31:0] wPC, wInstr,
	output wire [17:0] wControlSignals,
	output wire [5:0] wControlState,
	input wire [4:0] wVGASelect,
	output wire [31:0] wVGARead,
	//barramentos de dados
	output wire  DwReadEnable, DwWriteEnable,
	output wire [3:0] DwByteEnable,
	output wire [31:0] DwWriteData,
	input wire [31:0] DwReadData,
	output wire [31:0] DwAddress,
	// barramentos de instrucoes
	output wire  IwReadEnable, IwWriteEnable,
	output wire [3:0] IwByteEnable,
	output wire [31:0] IwWriteData,
	input wire [31:0] IwReadData,
	output wire [31:0] IwAddress,
	//interrupcoes
	input [7:0] iPendingInterrupt
);


/*************  UNICICLO *********************************/
`ifdef UNICICLO
// Visualizacao dos sinais de controle especi­ficos
wire [2:0] OrigPC, Mem2Reg;
wire [1:0] ALUOp,OrigALU, RegDst;
wire RegWrite;
assign wControlSignals={DwReadEnable,DwWriteEnable,RegWrite,RegDst[1:0],ALUOp[1:0],OrigALU[1:0],Mem2Reg[2:0],OrigPC[2:0]};
assign wControlState=6'b0;

Datapath_UNI Processor (
	.iCLK(iCLK),
	.iCLK50(iCLK50),
	.iRST(iRST),
	.iInitialPC(iInitialPC),

	.wPC(wPC),
	.woInstr(wInstr),
	.wDebug(wDebug),	
	.wRegDispSelect(wRegDispSelect),
	.wRegDisp(wRegDisp),
	.wRegDispFPU(wRegDispFPU),
	.wRegDispCOP0(wRegDispCOP0),
	.wFPUFlagBank(flagBank),
	.wVGASelect(wVGASelect),
	.wVGARead(wVGARead),
	
	.wCALUOp(ALUOp),
	.wCRegWrite(RegWrite),
	.wCRegDst(RegDst),
	.wCOrigALU(OrigALU),
	.wCMem2Reg(Mem2Reg),
	.wCOrigPC(OrigPC),

	// Barramento de dados
	.DwReadEnable(DwReadEnable), .DwWriteEnable(DwWriteEnable),
	.DwByteEnable(DwByteEnable),
	.DwWriteData(DwWriteData),
	.DwReadData(DwReadData),
	.DwAddress(DwAddress),	
	// Barramento de instrucoes
	.IwReadEnable(IwReadEnable), .IwWriteEnable(IwWriteEnable),
	.IwByteEnable(IwByteEnable),
	.IwWriteData(IwWriteData),
	.IwReadData(IwReadData),
	.IwAddress(IwAddress),	
	
	.iPendingInterrupt(iPendingInterrupt)	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	);
 `endif


/*************  MULTICICLO **********************************/
`ifdef MULTICICLO
// Sinais de controle especi­ficos
wire [1:0] ALUOp, ALUSrcA;
wire [2:0] ALUSrcB, PCSource;
wire IRWrite, IorD, PCWrite, RegDst;
wire RegWrite;
assign wControlSignals={DwReadEnable,DwWriteEnable,RegWrite,
RegDst,ALUOp[1:0],ALUSrcA[1:0],ALUSrcB[2:0],IorD,IRWrite,PCWrite,PCSource[2:0]};	
assign IwReadEnable=1'b0;
assign IwWriteEnable=1'b0;
assign IwByteEnable=4'b0000;
assign IwWriteData = 32'h00000000;
assign IwAddress = 32'h00000000;

Datapath_MULTI Processor (
	.iCLK(iCLK),
	.iCLK50(iCLK50),
	.iRST(iRST),
	.iInitialPC(iInitialPC),

	.oPC(wPC),
	.oInstr(wInstr),
	.oDebug(wDebug),
	.iRegDispSelect(wRegDispSelect),
	.oRegDisp(wRegDisp),
	.oFPRegDisp(wRegDispFPU),
	.oRegDispCOP0(wRegDispCOP0),
	.oFPUFlagBank(flagBank),
	.wVGASelect(wVGASelect),
	.wVGARead(wVGARead),
	
	.owControlState(wControlState),
	.oALUOp(ALUOp),
	.oPCSource(PCSource),
	.oALUSrcB(ALUSrcB),
	.oIRWrite(IRWrite),
	.oIorD(IorD),
	.oPCWrite(PCWrite),
	.oALUSrcA(ALUSrcA),
	.oRegWrite(RegWrite),
	.oRegDst(RegDst),
	
	//Barramento
	.DwWriteEnable(DwWriteEnable), .DwReadEnable(DwReadEnable),
	.DwByteEnable(DwByteEnable),
	.DwWriteData(DwWriteData),
	.DwAddress(DwAddress),
	.DwReadData(DwReadData),	

	.iPendingInterrupt(iPendingInterrupt) // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
);
`endif



	

/*************  PIPELINE **********************************/
`ifdef PIPELINE
// Sinais de controle especi­ficos
wire [2:0] OrigPC;
wire [1:0] ALUOp, OrigALU,RegDst;
wire RegWrite;
assign wControlSignals={DwReadEnable,DwWriteEnable,RegWrite,ALUOp[1:0],OrigALU[1:0],RegDst[1:0],OrigPC[2:0]};
assign wControlState=6'b111111;
assign wRegDispFPU=32'hDEDEB0B0;
assign wRegDispCOP0 = 32'hCACACACA;
assign flagBank = 8'hFF;
wire SavePC;
//wire wLock;
//assign wLock=1'b0;

Datapath_PIPEM Processor (
	.iCLK(iCLK),
	.iCLK50(iCLK50),
	.iRST(iRST),
	.iInitialPC(iInitialPC),
		
	.oPC(wPC),
	.oInstr(wInstr),
	.iRegDispSelect(wRegDispSelect),
	.oRegDisp(wRegDisp),
	.oDebug(wDebug),
	.iVGASelect(wVGASelect),
	.oVGARead(wVGARead),
	
	.oCALUOp(ALUOp),
	.oCRegWrite(RegWrite),
	.oCRegDst(RegDst),
	.oCOrigALU(OrigALU),
	.oCSavePC(SavePC),
	.oCOrigPC(OrigPC),
	
	// Barramento de dados
	.DwMemRead(DwReadEnable), .DwMemWrite(DwWriteEnable),
	.DwByteEnable(DwByteEnable),
	.DwMemWriteData(DwWriteData),
	.DwMemReadData(DwReadData),
	.DwMemAddress(DwAddress),	
	// Barramento de instrucoes
	.IwMemRead(IwReadEnable), .IwMemWrite(IwWriteEnable),
	.IwByteEnable(IwByteEnable),
	.IwMemWriteData(IwWriteData),
	.IwMemReadData(IwReadData),
	.IwMemAddress(IwAddress)	
	
	// Lock
	//.iSwitchLock(wLock)
);


endmodule
