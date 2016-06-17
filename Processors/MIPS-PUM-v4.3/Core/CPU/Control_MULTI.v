			
module Control_MULTI (
	iCLK, iRST, iOp, iFmt, iFt, iFunct, iV0, iSleepDone, oIRWrite, oMemtoReg,
	oMemWrite, oMemRead, oIorD, oPCWrite, oPCWriteBEQ, oPCWriteBNE, oPCSource, oALUOp,
	oALUSrcB, oALUSrcA, oRegWrite, oRegDst, oState, oStore, oSleepWrite, oFPDataReg, oFPRegDst,
	oFPPCWriteBc1t, oFPPCWriteBc1f, oFPRegWrite, oFPFlagWrite, oFPU2Mem,
	
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	iCOP0ALUoverflow, iCOP0FPALUoverflow, iCOP0FPALUunderflow, iCOP0FPALUnan,
	iCOP0UserMode, iCOP0ExcLevel, iCOP0PendingInterrupt, oCOP0PCOriginalWrite, oCOP0RegWrite,
	oCOP0Eret, oCOP0ExcOccurred, oCOP0BranchDelay, oCOP0ExcCode, oCOP0Interrupted,
	
	//adicionado no 1/2014
	oLoadCase, oWriteCase,
	
	//adicionado no 1/2016
	iRt
);

/* I/O type definition */
input wire iCLK, iRST, iSleepDone;
input wire [5:0] iOp, iFunct, iV0;
input wire [4:0] iFmt, iRt;		// 1/2016. Adicionado iRt.
input wire iFt;
output wire oIRWrite, oMemtoReg, oMemWrite, oMemRead, oIorD, oPCWrite, oPCWriteBEQ, oPCWriteBNE,
oRegWrite, oRegDst, oSleepWrite, oFPPCWriteBc1t, oFPPCWriteBc1f, oFPRegWrite, oFPFlagWrite, oFPU2Mem;
output wire [1:0] oALUOp, oALUSrcA, oFPDataReg, oFPRegDst;
output wire [2:0] oALUSrcB, oPCSource, oStore;
output wire [5:0] oState;

input iCOP0ALUoverflow, iCOP0FPALUoverflow, iCOP0FPALUunderflow, iCOP0FPALUnan, iCOP0UserMode, iCOP0ExcLevel;
input [7:0] iCOP0PendingInterrupt;
output oCOP0PCOriginalWrite;
output reg oCOP0RegWrite, oCOP0Eret, oCOP0ExcOccurred;
output oCOP0BranchDelay;
output [4:0] oCOP0ExcCode;
output oCOP0Interrupted;
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)

//reg [34:0] word;		// refeito para adicionar controles para o load e store
reg [39:0] word;			// 1/2014

reg [5:0] pr_state, nx_state;

//Adicionado em 1/2014
output wire [2:0] oLoadCase;
output wire [1:0] oWriteCase;


assign	oWriteCase = word[39:38];		//  1/2014
assign	oLoadCase = word[37:35];		//  1/2014
assign	oFPRegDst = word[34:33];
assign	oFPDataReg = word[32:31];
assign	oFPRegWrite = word[30];
assign	oFPPCWriteBc1t = word[29];
assign	oFPPCWriteBc1f = word[28];
assign	oFPFlagWrite = word[27];
assign	oFPU2Mem = word[26];
//assign	oClearJAction = word[25]; //Disponivel
//assign	oJReset 	= word[24];  //Disponivel
assign	oSleepWrite = word[23];
assign	oStore		= word[22:20];
assign	oPCWrite	= word[19];
assign	oPCWriteBNE	= word[18];
assign	oPCWriteBEQ	= word[17];
assign	oIorD		= word[16];
assign	oMemRead	= word[15];
assign	oMemWrite	= word[14];
assign	oIRWrite	= word[13];
assign	oMemtoReg	= word[12];
assign	oPCSource	= word[11:9];
assign	oALUOp		= word[8:7];
assign	oALUSrcB	= word[6:4];
assign	oALUSrcA	= word[3:2];
assign	oRegWrite	= word[1];
assign	oRegDst		= word[0];
assign	oState		= pr_state;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
assign 	oCOP0PCOriginalWrite = pr_state != COP0EXC;
assign 	oCOP0Interrupted = pr_state == COP0EXC && oCOP0ExcCode == EXCODEINT;

initial
begin
	pr_state	<= FETCH;
end

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire wCOP0PendingInterrupt;
assign oCOP0BranchDelay = iOp == OPCBEQ || iOp == OPCBNE || iOp == OPCJMP || iOp == OPCJAL || (iOp == OPCRFMT && iFunct == FUNJR) || (iOp == OPCFLT && iFmt == FMTBC1);
assign wCOP0PendingInterrupt = iCOP0PendingInterrupt != 8'b0 && ~iCOP0ExcLevel;

/* Main control block */
always @(posedge iCLK)
begin
	if (iRST)
		pr_state	<= FETCH;
	else
		pr_state	<= nx_state;
end

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
always @(*)
begin
	if (iOp == OPCRFMT && iFunct == FUNSYS)
		oCOP0ExcCode <= EXCODESYS;
	else if ((iOp == OPCRFMT && (iFunct == FUNADD || iFunct == FUNSUB) || iOp == OPCADDI) && iCOP0ALUoverflow)
		oCOP0ExcCode <= EXCODEALU;
	else if (
		iOp == OPCFLT && 
		(
			(((iFmt == FMTW && iFunct == FUNCVTSW) || (iFmt == FMTS && (iFunct == FUNADDS || iFunct == FUNSUBS || iFunct == FUNMULS || iFunct == FUNDIVS))) && (iCOP0FPALUoverflow || iCOP0FPALUunderflow)) ||
			(iFmt == FMTW && iFunct == FUNCVTWS && iCOP0FPALUoverflow)
		)
	)
		oCOP0ExcCode <= EXCODEFPALU;
	else if (iOp == OPCCOP0)
		oCOP0ExcCode <= EXCODEINSTR;
	else if (wCOP0PendingInterrupt)
		oCOP0ExcCode <= EXCODEINT;
	else
		oCOP0ExcCode <= EXCODEINSTR;
end

//always @(pr_state)
always @(*)
begin
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	oCOP0RegWrite <= pr_state == COP0MTC0;
	oCOP0Eret <= pr_state == COP0ERET;
	oCOP0ExcOccurred <= pr_state == COP0EXC;
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	
	case (pr_state)
		FETCH:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000010001010000000010000;
			nx_state	<= DECODE;
		end
		DECODE:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000000000000110000;
			case (iOp)
				OPCRFMT:
					if (iFunct == FUNJR)
					
						nx_state	<= wCOP0PendingInterrupt ? COP0EXC : JR;
					else if(iFunct == FUNSLL || iFunct == FUNSRL || iFunct == FUNSRA)
							nx_state	<= SHIFT;
						 else if(iFunct == FUNSYS)
							   begin
								case (iV0)
									SYSTIME:
										nx_state	<= TIME;
									SYSSLEEP:
										nx_state	<= SLEEP;
									SYSRNDINT:
										nx_state	<= RANDOM;
									default:
										nx_state	<= iCOP0UserMode ? COP0EXC : FETCH; //outros v0 manda para COP0EXC 
								endcase
							   end
							else
								nx_state	<= RFMT;
				OPCJMP:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : JUMP;
				OPCBEQ:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BEQ;
				OPCBNE:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BNE;
				OPCJAL:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : JAL;
					

				//operações implementadas em 1/2016 - bgtz, blez, bgez, bgezal, bgltz, bltzal.
				OPCBGTZ:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BGTZ;
				OPCBLEZ:
					nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BLEZ;
				OPCBGE_LTZ:
					case (iRt)
						RTBGEZ:
							nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BGEZ;
						RTBGEZAL:
							nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BGEZAL;
						RTBLTZ:
							nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BLTZ;
						RTBLTZAL:
							nx_state	<= wCOP0PendingInterrupt ? COP0EXC : BLTZAL;
					endcase
				
					//operaçoes adicionadas em 1/2014
					OPCLB,
					OPCLBU,
					OPCLH,
					OPCLHU,
					OPCSB,
					OPCSH,
					
				OPCLW,
				OPCSW,
				OPCLWC1,	//Load e Store da FPU
				OPCSWC1:
					nx_state	<= LWSW;
				OPCANDI,
				OPCORI,
				OPCXORI:
					nx_state	<= IFMTL;
/*				OPCJRCLR:
					nx_state	<= JRCLR;*/
				OPCADDI,
				OPCADDIU,
				OPCSLTI,
				OPCSLTIU,
				OPCLUI:
					nx_state	<= IFMTA;
				OPCFLT:
					case (iFmt)
						FMTMTC:
							nx_state <= FPUMTC1;
						FMTMFC:
							nx_state <= FPUMFC1;
						FMTBC1:
						begin
							if (wCOP0PendingInterrupt)
								nx_state <= COP0EXC;
							else if (iFt)
								nx_state <= FPUBC1T;
							else
								nx_state <= FPUBC1F;
						end
						FMTW,
						FMTS:
							case(iFunct)
								FUNMOV:
									nx_state	<= FPUMOV;
								FUNCEQ,
								FUNCLT,
								FUNCLE:
									nx_state	<= FPUCOMP;
								default:
									nx_state	<= FPUFR;
							endcase
						default:
							nx_state <= COP0EXC;
					endcase
					
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				OPCCOP0:
				begin
					case (iFmt)
						FMTMTC:
							nx_state <= iCOP0UserMode ? COP0EXC : COP0MTC0;
						FMTMFC:
							nx_state <= iCOP0UserMode ? COP0EXC : COP0MFC0;
						FMTERET:
							nx_state <= (iFunct != FUNERET) || iCOP0UserMode ? COP0EXC : COP0ERET;
						default:
							nx_state <= COP0EXC;
					endcase
				end
				// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
				
				default:
					nx_state	<= COP0EXC;
			endcase
		end
		
		FPUMTC1:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000001101000000000000000000000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUMFC1:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000010100000000000000000010;
			nx_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUBC1T:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000100000000000000000001000000000;
			nx_state <= FETCH;
		end
		
		FPUBC1F:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000010000000000000000001000000000;
			nx_state <= FETCH;
		end
		
		FPUMOV:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000111000000000000000000000000000000;
			nx_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUCOMP:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000001000000000000000000000000000;
			nx_state <= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		FPUFR:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000000000000000000;
			nx_state <= FPUFR2;
		end
		
		FPUFR2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000001000000000000000000000000000000;
			if (
				wCOP0PendingInterrupt ||
				(
					(
						(((iFmt == FMTW && iFunct == FUNCVTSW) || (iFmt == FMTS && (iFunct == FUNADDS || iFunct == FUNSUBS || iFunct == FUNMULS || iFunct == FUNDIVS))) && (iCOP0FPALUoverflow || iCOP0FPALUunderflow)) ||
						(iFmt == FMTW && iFunct == FUNCVTWS && iCOP0FPALUoverflow)
					) &&
					~iCOP0ExcLevel
				)
			)
				nx_state <= COP0EXC;
			else
				nx_state <= FETCH;
		end
		
		LWSW:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000000000000100100;
			/****D�VIDA AQUI***/
			case (iOp)
				OPCLW,
				
				OPCLB,OPCLBU,OPCLH,OPCLHU,		// 1/2014
				
				OPCLWC1:
					nx_state	<= LW;
				
				OPCSB:								// 1/2014
					nx_state <= STATE_SB;		// 1/2014
				OPCSH:								// 1/2014
					nx_state <= STATE_SH;		// 1/2014
					
				OPCSW:
					nx_state	<= SW;
				OPCSWC1:
					nx_state	<= FPUSWC1;
				default:
					nx_state	<= ERRO;
			endcase
		end
		LW:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000011000000000000000;
			case (iOp)
				OPCLW:
					nx_state	<= LW2;
				OPCLWC1:
					nx_state	<= FPULWC1;
				
				//Listinha de casos 1/2014
				OPCLB:
					nx_state <= STATE_LB;
				OPCLBU:
					nx_state <= STATE_LBU;
				OPCLH:
					nx_state <= STATE_LH;
				OPCLHU:
					nx_state <= STATE_LHU;
				
				default:
					nx_state	<= ERRO;
			endcase
		end
		FPULWC1:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000010011000000000000000000000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		FPUSWC1:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000100000000010100000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		LW2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000001000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_LB:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0001100000000000000000000001000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_LBU:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0010000000000000000000000001000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_LH:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000100000000000000000000001000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_LHU:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0001000000000000000000000001000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_SB:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b1000000000000000000000010100000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		STATE_SH:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0100000000000000000000010100000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
/********************************************************************************************************************/
		SW:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst		
			word	<= 40'b0000000000000000000000010100000000000000;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		RFMT:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000000000100000100;
			case (iFunct)
				FUNMULT,
				FUNDIV,
				FUNMULTU,
				FUNDIVU:
					nx_state	<= FETCH;
				default:
					nx_state	<= RFMT2;
			endcase
		end
		RFMT2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000000000000000000011;
			nx_state	<= ((iFunct == FUNADD || iFunct == FUNSUB) && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		SHIFT:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000000000000000100001000;
			nx_state	<= RFMT2;
		end
		IFMTL:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst		
			word	<= 40'b0000000000000000000000000000000111000100;
			nx_state	<= IFMT2;
		end
		IFMTA:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst		
			word	<= 40'b0000000000000000000000000000000110100100;
			nx_state	<= IFMT2;
		end
		IFMT2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000000000000000000000010;
			nx_state	<= (iOp == OPCADDI && iCOP0ALUoverflow && ~iCOP0ExcLevel) || wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end	
		BEQ:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000100000001010000100;
			nx_state	<= FETCH;
		end
		BNE:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000001000000001010000100;
			nx_state	<= FETCH;
		end
		JUMP:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000010000000010000000000;
			nx_state	<= FETCH;
		end
		JAL:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000110000000010111010010;
			nx_state	<= FETCH;
		end
		
		
		//adicionado em 1/2016, bgez, bgezal, bltz, bltzal.
		BGEZ:
		begin
			word	<= 40'b0000000000000000000000100000001111010100;
			nx_state	<= FETCH;
		end
		
		BGEZAL:
		begin
			word	<= 40'b0000000000000000000100100000001111010110;
			nx_state	<= FETCH;
		end
		
		BLTZ:
		begin
			word	<= 40'b0000000000000000000001000000001111010100;
			nx_state	<= FETCH;
		end
		
		BLTZAL:
		begin
			word	<= 40'b0000000000000000011101000000001111010110;
			nx_state	<= FETCH;
		end
		
		BGTZ: //1/2016
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000000100000001111010100;
			nx_state	<= FETCH;
		end
		BLEZ://1/2016
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000000000001000000001111010100;
			nx_state	<= FETCH;
		end

		JR:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000010000000011000000000;
			nx_state	<= FETCH;
		end
		
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		COP0MTC0:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000000000000000000000000;
			nx_state	<= FETCH;
		end
		COP0MFC0:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000011000000000000000000010;
			nx_state	<= FETCH;
		end
		COP0ERET:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst			
			word	<= 40'b0000000000000000000010000000101000000000;
			nx_state	<= FETCH;
		end
		COP0EXC:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst					
			word	<= 40'b0000000000000000000010000000100000000000;
			nx_state	<= FETCH;
		end
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		
		TIME:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst					
			word	<= 40'b0000000000000000001000000000000000000010;
			nx_state	<= TIME2;
		end
		TIME2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst				
			word	<= 40'b0000000000000000001100000000000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		SLEEP:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst				
			word	<= 40'b0000000000000000100000000000000000000000;
			nx_state	<= SLEEP2; 
		end
		SLEEP2:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst				
			word	<= 40'b0000000000000000000000000000000000000000;
			if(iSleepDone)
				nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
			else
				nx_state <= SLEEP2;
		end
		RANDOM:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word  <= 40'b0000000000000000010000000000000000000010;
			nx_state	<= wCOP0PendingInterrupt ? COP0EXC : FETCH;
		end
		
		ERRO:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word  <= 40'b0000000000000000000000000000000000000001;
			nx_state	<= ERRO;
		end
/*		JOY:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000010010110000000101000000010;
			nx_state	<= FETCH;
		end
		JRCLR:
		begin
			//FPRegDst[2], FPDataReg[2], FPRegWrite, FPPCWriteBc1t, FPPCWriteBc1f, FPFlagWrite, FPU2Mem, ClearJAction, JReset, SleepWrite, Store[3], PCWrite, PCWriteBNE, PCWriteBEQ, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource[3], ALUop[2], ALUSrcB[3], ALUSrcA[2], RegWrite, RegDst
			word	<= 40'b0000000000000001000010000000011000000000;
			nx_state	<= FETCH;
		end*/
		default:
		begin
			word	<= 40'b0;
			nx_state	<= ERRO;
		end
	endcase
end

endmodule
