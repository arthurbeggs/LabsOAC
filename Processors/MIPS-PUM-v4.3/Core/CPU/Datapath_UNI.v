/*
 * Caminho de dados processador uniciclo
 *
 */

module Datapath_UNI (
    // Inputs e clocks
    input  wire        iCLK, iCLK50, iRST,
    input  wire [31:0] iInitialPC,

    // Para monitoramento
    output wire [31:0] wPC, woInstr,
    output wire [31:0] wRegDisp, wRegDispFPU, wRegDispCOP0,
    input  wire [4:0]  wRegDispSelect,
    output wire [31:0] wDebug,
    output wire [7:0]  wFPUFlagBank,
    input       [4:0]  wVGASelect, wVGASelectFPU,
    output      [31:0] wVGARead, wVGAReadFPU,

    output wire        wCRegWrite,
    output wire [1:0]  wCRegDst,wCALUOp,wCOrigALU,
    output wire [2:0]  wCOrigPC,
    output wire [2:0]  wCMem2Reg,

    //  Barramento de Dados
    output             DwReadEnable, DwWriteEnable,
    output      [3:0]  DwByteEnable,
    output      [31:0] DwAddress, DwWriteData,
    input       [31:0] DwReadData,

    // Barramento de Instrucoes
    output             IwReadEnable, IwWriteEnable,
    output      [3:0]  IwByteEnable,
    output      [31:0] IwAddress, IwWriteData,
    input       [31:0] IwReadData,

    input [7:0] iPendingInterrupt                           // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
    );


assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;

/* Padrao de nomeclatura
 *
 * XXXXX - registrador XXXX
 * wXXXX - wire XXXX
 * wCXXX - wire do sinal de controle XXX
 * memXX - memoria XXXX
 * Xunit - unidade funcional X
 * iXXXX - sinal de entrada/input
 * oXXXX - sinal de saida/output
 */

reg  [31:0] PC, PCgambs;                                    // registrador do PC
wire [31:0] wPC4;
wire [31:0] wiPC;
wire [31:0] wInstr;
wire [31:0] wMemDataWrite;
wire [4:0]  wAddrRs, wAddrRt, wAddrRd, wRegDst, wShamt;     // enderecos dos reg rs,rt ,rd e saida do Mux regDst
wire [31:0] wOrigALU;
wire        wZero;
wire [4:0]  wALUControl;
wire [31:0] wALUresult, wRead1, wRead2, wMemAccess;
wire [31:0] wReadData;
wire [31:0] wDataReg;
wire [15:0] wImm;
wire [31:0] wExtImm;
wire [31:0] wBranchPC;
wire [31:0] wJumpAddr;
wire        wOverflow;
wire [31:0] wExtZeroImm;
wire        wCMemRead, wCMemWrite;
wire [5:0]  wOpcode, wFunct;

/*Neste bloco estao definidos os controles dos multiplexadores e outras coisas da FPU*/
wire        wCRegWriteFPU, wCRegDataFPU, wSelectedFlagValue, wCFPFlagWrite, wCompResult;
wire [1:0]  wCDataRegFPU, wCRegDstFPU, wCFPUparaMem;
wire        wZeroFPU, wNanFPU, wUnderflowFPU, wOverflowFPU, wBranchC1;
wire [4:0]  wAddrFt, wAddrFs, wAddrFd, wFmt, wRegDstFPU;
wire [2:0]  wFlagSelector, wBranchFlagSelector;
wire [3:0]  wFPALUControl;
wire [31:0] wDataRegFPU;
wire [31:0] wFPALUresult;
wire [31:0] wRead1FPU, wRead2FPU;
/*******/

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire        wCRegWriteCOP0;
wire        wCEretCOP0;
wire        wCExcOccurredCOP0;
wire        wCBranchDelayCOP0;
wire [4:0]  wCExcCodeCOP0;
wire [31:0] wDataRegCOP0;
wire [31:0] wCOP0ReadData;
wire [7:0]  wCOP0InterruptMask;
wire        wCOP0UserMode;
wire        wCOP0ExcLevel;
wire [31:0] wMemStore;
wire [3:0]  wMemEnableStore;
wire [3:0]  wMemEnable;

//Semestre 2014/2 para implementacao do bootloader
wire        wCodeMemoryWrite;

/* Inicializacao */
initial
begin
    PC         <= BEGINNING_TEXT;
    PCgambs    <= BEGINNING_TEXT;
end

assign wPC4         = wPC + 32'h4;                          /* Calculo PC+4 */
assign wBranchPC    = wPC4 + {wExtImm[29:0],{2'b00}};       /* Endereco do Branch */
assign wJumpAddr    = {wPC4[31:28],wInstr[25:0],{2'b00}};   /* Endereco do Jump */
assign wPC          = PC;
assign wOpcode      = wInstr[31:26];
assign wAddrRs      = wInstr[25:21];
assign wAddrRt      = wInstr[20:16];
assign wAddrRd      = wInstr[15:11];
assign wShamt       = wInstr[10:6];
assign wFunct       = wInstr[5:0];
assign wImm         = wInstr[15:0];
assign wExtZeroImm  = {{16'b0},wImm};
assign wExtImm      = {{16{wImm[15]}},wImm};
assign woInstr      = wInstr;
assign wCodeMemoryWrite     = ((PC >= BEGINNING_BOOT && PC <= END_BOOT) ? 1'b1 : 1'b0);

/* Assigns para debug */
assign wDebug   = 32'h0ACEF0DA;

/*Assigns FPU*/
assign wFmt                 = wInstr[25:21];
assign wAddrFt              = wInstr[20:16];
assign wAddrFs              = wInstr[15:11];
assign wAddrFd              = wInstr[10:6];
assign wFlagSelector        = wInstr[10:8];
assign wBranchFlagSelector  = wInstr[20:18];
assign wBranchC1            = wInstr[16];
assign wSelectedFlagValue   = wFPUFlagBank[wBranchFlagSelector];


/* Barramento da Memoria de Instrucoes */
assign    IwReadEnable      = ON;
assign    IwWriteEnable     = wCodeMemoryWrite;
assign    IwByteEnable      = wMemEnable;
assign    IwAddress         = wPC;
assign    IwWriteData       = ZERO;
assign    wInstr            = IwReadData;


/* Banco de Registradores */
Registers RegsUNI (
    .iCLK(iCLK),
    .iCLR(iRST),
    .iReadRegister1(wAddrRs),
    .iReadRegister2(wAddrRt),
    .iWriteRegister(wRegDst),
    .iWriteData(wDataReg),
    .iRegWrite(wCRegWrite),
    .oReadData1(wRead1),
    .oReadData2(wRead2),
    .iRegDispSelect(wRegDispSelect),    // seleção para display
    .oRegDisp(wRegDisp),                // Reg display
    .oRegA0(),                          // usado no multiciclo
    .oRegV0(),                          // usado no multiciclo para syscall em hardware
    .iVGASelect(wVGASelect),            // para mostrar Regs na tela
    .oVGARead(wVGARead)                 // para mostrar Regs na tela
);

/*Banco de Registradores FPU*/
FPURegisters memRegFPU(
    .iCLK(iCLK),
    .iCLR(iRST),
    .iReadRegister1(wAddrFs),
    .iReadRegister2(wAddrFt),
    .iWriteRegister(wRegDstFPU),
    .iWriteData(wDataRegFPU),
    .iRegWrite(wCRegWriteFPU),
    .oReadData1(wRead1FPU),
    .oReadData2(wRead2FPU),
    .iRegDispSelect(wRegDispSelect),    // para mostrar Regs no display
    .oRegDisp(wRegDispFPU),             // para mostrar Regs no display
    .iVGASelect(wVGASelectFPU),         // para mostrar Regs na tela
    .oVGARead(wVGAReadFPU)              // para mostrar Regs na tela
);

/* FP ALU Control */
FPALUControl FPALUControlUnit (
    .iFunct(wFunct),
    .oControlSignal(wFPALUControl)
);

/*ULA FPU*/
ula_fp FPALUunit (
    .iclock(iCLK50),
    .idataa(wRead1FPU),
    .idatab(wRead2FPU),
    .icontrol(wFPALUControl),
    .oresult(wFPALUresult),
    .onan(wNanFPU),
    .ozero(wZeroFPU),
    .ounderflow(wUnderflowFPU),
    .ooverflow(wOverflowFPU),
    .oCompResult(wCompResult)
);

/* Banco de flags da FPU*/
FlagBank FlagBankModule(
    .iCLK(iCLK),
    .iCLR(iRST),
    .iFlag(wFlagSelector),
    .iFlagWrite(wCFPFlagWrite),
    .iData(wCompResult),
    .oFlags(wFPUFlagBank)
);

/* ALU CTRL */
ALUControl ALUControlunit (
    .iFunct(wFunct),
    .iOpcode(wOpcode),
    .iRt(wAddrRt),          // 1/2016, Implementar intruções bgez, bgezal, bgltz, bltzal.
    .iALUOp(wCALUOp),
    .oControlSignal(wALUControl)
);

/* ALU */
ALU ALUunit(
    .iCLK(iCLK),
    .iRST(iRST),
    .iControlSignal(wALUControl),
    .iA(wRead1),
    .iB(wOrigALU),
    .iShamt(wShamt),
    .oALUresult(wALUresult),
    .oZero(wZero),
    .oOverflow(wOverflow)
);

MemStore MemStore0 (
    .iAlignment(wALUresult[1:0]),
    .iWriteTypeF(STORE_TYPE_DUMMY),
    .iOpcode(wOpcode),
    .iData(wRead2),
    .oData(wMemStore),
    .oByteEnable(wMemEnableStore),
    .oException()
);

/* Barramento da memoria de dados */
assign DwReadEnable     = wCMemRead;
assign DwWriteEnable    = wCMemWrite;
assign DwByteEnable     = wMemEnable;
assign DwWriteData      = wMemDataWrite;
assign wReadData        = DwReadData;
assign DwAddress        = wALUresult;

MemLoad MemLoad0 (
    .iAlignment(wALUresult[1:0]),
    .iLoadTypeF(LOAD_TYPE_DUMMY),
    .iOpcode(wOpcode),
    .iData(wReadData),
    .oData(wMemAccess),
    .oException()
);

/* Unidade de Controle */
Control_UNI CtrUNI (
    .iCLK(iCLK),
    .iOp(wOpcode),
    .iFunct(wFunct),
    .iFmt(wFmt),
    .iBranchC1(wBranchC1),
    .oRegDst(wCRegDst),
    .oOrigALU(wCOrigALU),
    .oMemparaReg(wCMem2Reg),
    .oEscreveReg(wCRegWrite),
    .oLeMem(wCMemRead),
    .oEscreveMem(wCMemWrite),
    .oOpALU(wCALUOp),
    .oOrigPC(wCOrigPC),
    .oEscreveRegFPU(wCRegWriteFPU),
    .oRegDstFPU(wCRegDstFPU),
    .oFPUparaMem(wCFPUparaMem),
    .oDataRegFPU(wCDataRegFPU),
    .oFPFlagWrite(wCFPFlagWrite),

    // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
    .iExcLevel(wCOP0ExcLevel),
    .iALUOverflow(wOverflow),
    .iFPALUOverflow(wOverflowFPU),
    .iFPALUUnderflow(wUnderflowFPU),
    .iFPALUNaN(wNanFPU),
    .iUserMode(wCOP0UserMode),    // para detectar instrucoes reservadas
    .iPendingInterrupt(wCOP0InterruptMask),
    .oEscreveRegCOP0(wCRegWriteCOP0),
    .oEretCOP0(wCEretCOP0),
    .oExcOccurredCOP0(wCExcOccurredCOP0),
    .oBranchDelayCOP0(wCBranchDelayCOP0),
    .oExcCodeCOP0(wCExcCodeCOP0),
    .iRt(wAddrRt)                       // 1/2016, Implementar intruções bgez, bgezal, bgltz, bltzal.
);

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Banco de registradores do Coprocessador 0 */
COP0RegistersUNI cop0reg (
    .iCLK(iCLK),
    .iCLR(iRST),

    // register file interface
    .iReadRegister(wAddrRd),
    .iWriteRegister(wAddrRd),
    .iWriteData(wDataRegCOP0),
    .iRegWrite(wCRegWriteCOP0),
    .oReadData(wCOP0ReadData),

    // eret interface
    .iEret(wCEretCOP0),

    // COP0 interface
    .iExcOccurred(wCExcOccurredCOP0),
    .iBranchDelay(wCBranchDelayCOP0),
    .iPendingInterrupt(iPendingInterrupt),
    .iExcCode(wCExcCodeCOP0),
    .oInterruptMask(wCOP0InterruptMask),
    .oUserMode(wCOP0UserMode),
    .oExcLevel(wCOP0ExcLevel),

    // DE2-70 interface
    .iRegDispSelect(wRegDispSelect),
    .oRegDisp(wRegDispCOP0)
);

/* Multiplexadores */
/*Decide em qual registrador o dado sera escrito*/
always @(*)
    case(wCRegDst)
        2'b00:      wRegDst = wAddrRt;
        2'b01:      wRegDst = wAddrRd;
        2'b10:      wRegDst = wZero  ? 5'd31: 5'd0;     //  $ra ou $zero    1/2016
        2'b11:      wRegDst = ~wZero ? 5'd31: 5'd0;     //  $ra ou $zero    1/2016
        default:    wRegDst = 5'd0;
    endcase


/*Decide o que entrara na segunda entrada da ULA*/
always @(*)
    case(wCOrigALU)
        2'b00:      wOrigALU = wRead2;
        2'b01:      wOrigALU = wExtImm;
        2'b10:      wOrigALU = wExtZeroImm;
        2'b11:      wOrigALU = 5'b00000;     //adicionado em 1/2016 para implementação dos branchs
    endcase


/*Decide qual sera o proximo PC*/
always @(*)
begin
    if (wCExcOccurredCOP0)                              // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
        wiPC = BEGINNING_KTEXT;                         //.ktext
    else
    begin
        case(wCOrigPC)
            3'b000:     wiPC = wPC4;
            3'b001:     wiPC = wZero ? wBranchPC: wPC4;
            3'b010:     wiPC = wJumpAddr;
            3'b011:     wiPC = wRead1;
            3'b100:     wiPC = wCOP0ReadData;           // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0). instrucao eret
            3'b101:     wiPC = ~wZero ? wBranchPC: wPC4;
            3'b110:     wiPC = wSelectedFlagValue ? wBranchPC : wPC4;
            3'b111:     wiPC = ~wSelectedFlagValue ? wBranchPC : wPC4;
        endcase
    end
end

/*Decide o que sera escrito no banco de registradores*/
always @(*)
    case(wCMem2Reg)
        3'b000:     wDataReg = wALUresult;
        3'b001:     wDataReg = 32'hE0E0E0E0;            //wReadData;  // Slot vago, LW foi passada para wMemAcess
        3'b010:     wDataReg = wPC4;
        3'b011:     wDataReg = {wImm, 16'b0};
        3'b100:     wDataReg = wRead1FPU;
        3'b101:     wDataReg = wCOP0ReadData;           // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
        3'b110:     wDataReg = wMemAccess;              // feito pelo PA
        default:    wDataReg = 32'b0;
    endcase


/*Decide em qual registrador sera escrito o dado na FPU*/
always @(*)
    case(wCRegDstFPU)
        2'b00:      wRegDstFPU = wAddrFd;
        2'b01:      wRegDstFPU = wAddrFs;
        2'b10:      wRegDstFPU = wAddrFt;
        default:    wRegDstFPU = 5'b0;
    endcase


/*Decide o que sera escrito no banco de registradores da FPU*/
wire [31:0] wx1;
assign wx1 = (wReadData==32'hzzzzzzzz ? 32'h00000000 : wReadData);
always @(*)
    case(wCDataRegFPU)
        2'b00:      wDataRegFPU = wFPALUresult;
        2'b01:      wDataRegFPU = wx1;
        2'b10:      wDataRegFPU = wRead2;
        2'b11:      wDataRegFPU = wRead1FPU;
        default:    wDataRegFPU = 5'b0;
    endcase

/*Decide o que sera escrito na Memoria de Dados*/
always @(*)
    case(wCFPUparaMem)
        2'b00:                                          // Nao deve estar mais sendo usado para sw
            begin
            wMemDataWrite   = wRead2;
            wMemEnable      = 4'b1111;
            end
        2'b01:
            begin
            wMemDataWrite   = wRead2FPU;
            wMemEnable      = 4'b1111;
            end
        2'b10:
            begin
            wMemDataWrite   = wMemStore;
            wMemEnable      = wMemEnableStore;
            end
        default:
            begin
            wMemDataWrite   = 32'b0;
            wMemEnable      = 4'b1111;
            end
    endcase

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Decide o que sera escrito no banco de registradores do Coprocessador 0 */
always @(*)
    case(wCExcOccurredCOP0)
        1'b0:   wDataRegCOP0 = wRead2;
        1'b1:   wDataRegCOP0 = PCgambs - 4;   //////  VERIFICAR SE -4 ESTA CORRETO PARA FICAR IGUAL AO MARS
    endcase


/* Para cada ciclo de Clock */

always @(posedge iCLK)
begin
    if(iRST)
    begin
        PC      <= iInitialPC;
        PCgambs <= iInitialPC;
    end
    else begin
        PC <= wiPC;
        if (~wCExcOccurredCOP0)
            PCgambs <= wiPC;
    end
end

endmodule
