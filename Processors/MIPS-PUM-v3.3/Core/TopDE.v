/* **************************************************** */
/* * Escolha o tipo de processador a ser implementado * */

`define UNICICLO
//`define MULTICICLO
//`define PIPELINE


/*   ******************  Historico ***********************
 Top Level para processador MIPS UNICICLO v0 baseado no processador desenvolvido por
Alexandre Lins							09/40097
Daniel Dutra							09/08436
*Yuri Maia								09/16803
em 2010/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v1 baseado no processador desenvolvido por
Emerson Grzeidak						09/93514
Gabriel Calache Cozendey				09/47946
Glauco Medeiros Volpe					10/25091
*Luiz Henrique Dias Navarro				10/00748
Waldez Azevedo Gomes Junior				10/08617
em 2011/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v2 baseado no processador desenvolvido por
*Antonio Martino Neto					09/89886
Bruno de Matos Bertasso					08/25590
Carolina S. R. de Oliveira  			07/45006
Herman Ferreira M. de Asevedo			09/96319
Renata Cristina							09/0130600
em 2011/2 na disciplina OAC

 Top Level para processador MIPS UNICICLO v3 baseado no processador desenvolvido por
Andre Franca							10/0007457
Felipe Carvalho Gules					08/29137
Filipe Tancredo Barros					10/0029329
Guilherme Ferreira						12/0051133
*Vitor Coimbra de Oliveira				10/0021832
em 2012/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v4 baseado no processador desenvolvido por
Alexandre Dantas						10/0090788
Ciro Viana								09/0137531
*Matheus Pimenta						09/0125789
em 2013/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v6 baseado no processador desenvolvido por
Vitor de Alencastro Lacerda				11/0067142
*Hugo Luis Andrade Silva				12/0012987
em 2013/2 na disciplina OAC

Top Level para processador MIPS UNICICLO v7 baseado no processador desenvolvido por
*Thales Marques Ramos					09/0133421
Daniel Magalhaes dos Santos				11/0113403
Gustavo Ribeiro Teixeira				09/0115791
Lorena Goncalves Miquett				10/0015581
Thales Moreira Vinkler					10/0050638
Wilson Domingos Sidinei Alves Miranda	14/0053344
em 2014/1 na disciplina OAC

Top Level para processador MIPS MULTICICLO v0 baseado no processador desenvolvido por
David A. Patterson e John L. Hennessy
Computer Organization and Design
3a Edicao

Top Level para processador MIPS MULTICICLO v01 baseado no processador desenvolvido por
Alexandre Lins							09/40097
Daniel Dutra							09/08436
*Yuri Maia								09/16803
em 2010/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v1 baseado no processador desenvolvido por
Emerson Grzeidak 						09/93514
Gabriel Calache Cozendey 				09/47946
Glauco Medeiros Volpe 					10/25091
*Luiz Henrique Dias Navarro 			10/00748
Waldez Azevedo Gomes Junior				10/08617
em 2011/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v2 baseado no processador desenvolvido por
*Antonio Martino Neto					09/89886
Bruno de Matos Bertasso					08/25590
Carolina S. R. de Oliveira				07/45006
Herman Ferreira M. de Asevedo			09/96319
Renata Cristina							09/0130600
em 2011/2 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v9 baseado no processador desenvolvido por
Andre Franca							10/0007457
Felipe Carvalho Gules					08/29137
Filipe Tancredo Barros					10/0029329
Guilherme Ferreira						12/0051133
*Vitor Coimbra de Oliveira				10/0021832
em 2012/1 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v10 baseado no processador desenvolvido por
Alexandre Dantas						10/0090788
Ciro Viana								09/0137531
*Matheus Pimenta						09/0125789
em 2013/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v1 baseado no processador desenvolvido por
Andre Figueira Lourenco					09/89525
Jose Chaves Junior						08/40122
Hugo Marello							10/29444
em 2010/2 na disciplina OAC

Top Level para processador MIPS PIPELINE v1.5 baseado no processador desenvolvido por
Emerson Grzeidak						09/93514
Gabriel Calache Cozendey				09/47946
Glauco Medeiros Volpe					10/25091
*Luiz Henrique Dias Navarro				10/00748
Waldez Azevedo Gomes Junior				10/08617
em 2011/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v2 baseado no processador desenvolvido por
*Antonio Martino Neto					09/89886
Bruno de Matos Bertasso					08/25590
Carolina S. R. de Oliveira				07/45006
Herman Ferreira M. de Asevedo			09/96319
Renata Cristina							09/0130600
em 2012/1 na disciplina OAC

Top Level para processador MIPS PIPELINE v3 baseado no processador desenvolvido por
Antonio Martino Neto					09/89886
em 2013/1 na disciplina TG1

Top Level para processador MIPS PIPELINE v4 baseado no processador desenvolvido por
*Hugo Luis Andrade Silva 				12/0012987
Leonardo de Oliveira Lourenco			13/0120197
*Thales Marques Ramos					09/0133421
Daniel Magalhaes dos Santos				11/0113403
Marcus da Silva Ferreira				10/0056881
Wilson Domingos Sidinei Alves Miranda	11/0144201
em 2013/2 na disciplina OAC

 V8.2 Com eret para PC (calcular PC+4 no programa)
 v8.3 Arrumado todos os PARAMETROS, ULA nova
 v9 com RS232 e BootLoader baseado no processador desenvolvido por
Filipe Lima								09/0113802
Sinayra Moreira							10/0020666
Tulio Matias							10/0055150
*Gabriel Naves							12/0011867
Gabriel Sousa							12/0060353
Icaro Mota								12/0051389
em 2014/2 na disciplina OAC

Com sintetizador de áudio programável e MTHI/MTLO
*Maxwell M. Fernandes					10/0116175
Túlio de Carvalho Matias				10/0055150
*Luiz Henrique Campos Barboza			09/0010256
*Diego Marques de Azevedo				11/0027876
Marcos de Moura Gonçalves				15/0093349
Yuri Barcellos Galli					12/0024098
em 2015/1 na disciplina OAC

 Adaptado para a placa de desenvolvimento DE2-70.
 Prof. Marcus Vinicius Lamar   2015/2
 UnB - Universidade de Brasilia
 Dep. Ciencia da Computacao

 */


module TopDE (
	/* I/O type definition */
	input 		 		iCLK_50, iCLK_50_2, iCLK_28, iCLK_50_4,		// Clocks
	input 		 [3:0]	iKEY,				// KEYs
	input 		 [17:0]	iSW,				// Switches
	output 		 [8:0]	oLEDG,				// LEDs Green
	output 		 [17:0]	oLEDR,  			// LEDs Red
	output 		 [6:0]	oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D,		// Displays Hex
	output 		 		oHEX0_DP, oHEX1_DP, oHEX2_DP, oHEX3_DP, oHEX4_DP, oHEX5_DP, oHEX6_DP, oHEX7_DP,		// Displays Dot Point


	// GPIO_0
	// input 	[31:0] GPIO_0,
	// output 	[31:0] GPIO_1,

	//VGA interface
	output 				oVGA_CLOCK, oVGA_HS, oVGA_VS, oVGA_BLANK_N, oVGA_SYNC_N,
	output 		 [9:0]	oVGA_R, oVGA_G, oVGA_B,

	// TV Decoder
	output 				oTD1_RESET_N, 		// TV Decoder Reset

	// I2C
	inout  				I2C_SDAT, 			// I2C Data
	output 				oI2C_SCLK, 			// I2C Clock

	// Audio CODEC
	inout  				AUD_ADCLRCK, 		// Audio CODEC ADC LR Clock
	input  				iAUD_ADCDAT, 		// Audio CODEC ADC Data
	output  			AUD_DACLRCK, 		// Audio CODEC DAC LR Clock
	output 				oAUD_DACDAT,  		// Audio CODEC DAC Data
	inout  				AUD_BCLK,			// Audio CODEC Bit-Stream Clock
	output 				oAUD_XCK,	 		// Audio CODEC Chip Clock

	// PS2 Keyborad
	inout 				PS2_KBCLK,
	inout 				PS2_KBDAT,

	//	Modulo LCD 16X2
	inout 		 [7:0]	LCD_D,				// LCD Data bus 8 bits
	output 				oLCD_ON,			// LCD Power ON/OFF
	output 				oLCD_BLON,			// LCD Back Light ON/OFF
	output 				oLCD_RW,			// LCD Read/Write Select, 0 = Write, 1 = Read
	output 				oLCD_EN,			// LCD Enable
	output 				oLCD_RS,			// LCD Command/Data Select, 0 = Command, 1 = Data

	// SRAM Interface
	inout 		 [31:0] SRAM_DQ,			// SRAM Data Bus 32 Bits
	output 		 [18:0]	oSRAM_A,			// SRAM Address bus 21 Bits
	output 				oSRAM_ADSC_N, 		// SRAM Controller Address Status
	output 				oSRAM_ADSP_N, 		// SRAM Processor Address Status
	output 				oSRAM_ADV_N, 		// SRAM Burst Address Advance
	output 		 [3:0]	oSRAM_BE_N, 		// SRAM Byte Write Enable
	output 				oSRAM_CE1_N, 		// SRAM Chip Enable
	output 				oSRAM_CE2, 			// SRAM Chip Enable
	output 				oSRAM_CE3_N, 		// SRAM Chip Enable
	output 				oSRAM_CLK, 			// SRAM Clock
	output 				oSRAM_GW_N, 		// SRAM Global Write Enable
	output 				oSRAM_OE_N, 		// SRAM Output Enable
	output 				oSRAM_WE_N, 		// SRAM Write Enable

	// Interface Serial RS-232
	output 				oUART_TXD,			//	UART Transmitter
	input 				iUART_RXD,			//	UART Receiver
	output 				oUART_CTS,		 	//	UART Clear To Send
	input 				iUART_RTS,			//	UART Request To Send

	// Para simulacao em forma de onda do TopDE
	output 				OCLK, OCLK100, OCLK200, OCLK_2x,
	output 		 [4:0] 	OwRegDispSelect,
	output 		 [31:0] OwPC,OwInstr,OwRegDisp,OwRegDispFPU,
	output 		 [7:0] 	OflagBank,
	output 				ODReadEnable, ODWriteEnable,
	output 		 [31:0] ODAddress, ODWriteData, ODReadData,
	output 		 [31:0] OIAddress, OIReadData
);

// Para simulacao de forma de onda
assign 	OCLK 			= CLK;
assign 	OCLK_2x 		= CLK_2x;
assign 	OCLK100 		= iCLK_100;
assign 	OCLK200 		= iCLK_200;
assign 	OwPC 			= wPC;
assign 	OwInstr 		= wInstr;
assign 	OwRegDispSelect = wRegDispSelect;
assign 	OwRegDisp 		= wRegDisp;
assign 	OwRegDispFPU 	= wRegDispFPU;
assign 	OflagBank 		= flagBank;
assign 	ODReadEnable 	= DReadEnable;
assign 	ODWriteEnable	= DWriteEnable;
assign 	ODAddress		= DAddress;
assign 	ODWriteData 	= DWriteData;
assign 	ODReadData 		= DReadData;
assign 	OIAddress 		= IAddress;
assign 	OIReadData 		= IReadData;


/**** Gerador e gerenciador de Clock *******************************/
wire 	 	CLK, CLK_2x, iCLK_100, iCLK_200;			// NOTE: CLK_2x declarado, mas não atribuido. assign comentado? Sem driver nem valor inicial.
wire 	 	Reset, CLKSelectFast, CLKSelectAuto;

CLOCK_Interface CLKI0(
	.iCLK_50(iCLK_50),  				// 50MHz
	.iCLK_50_4(iCLK_50_4), 				// 50MHz
	.oCLK_100(iCLK_100),
	.oCLK_200(iCLK_200),
	.CLK(CLK),  						// Clock da CPU
	// .CLK_2x(CLK_2x),					// 2 x Clock CPU  (usado nas memorias)
	// .CLK_X(CLK_X),  					// Clock gerado por PLL ou 50MHz
	.Reset(Reset),  					// Reset de todos os dispositivos
	.CLKSelectFast(CLKSelectFast),  	// Visualização
	.CLKSelectAuto(CLKSelectAuto),  	// Visualização
	.iKEY(iKEY),  						// Controles dos clocks e reset
	.fdiv(iSW[7:0]), 					// Divisor da frequencia CLK = iCLK_50/fdiv
	.Timmer(iSW[10])   					// Timmer de 10 segundos
);


/* LEDs sinais de controle */
assign 	oLEDR 		= wSinaisControle; 	// Varia de acordo com o processador
assign 	oLEDG[5:0]	= wControlState;
assign 	oLEDG[6] 	= CLKSelectFast;
assign 	oLEDG[7] 	= CLKSelectAuto;
assign 	oLEDG[8] 	= CLK;


/* 7 segment display register content selection */
assign 	wRegDispSelect	= iSW[17:13];


// Interface dos displays e chaves
assign wOutput	= (iSW[12] ? (iSW[17] ? wPC :  							// PC
									iSW[16] ? wInstr :   				// Instrucao
									iSW[15] ? {25'b0,wInstr[31:26]} : 	// Opcode
									iSW[14] ? {25'b0,wInstr[6:0]} : 	// Funct
									iSW[13] ? wDebug : {3'b0, flagBank[7], 3'b0, flagBank[6], 3'b0, flagBank[5], 3'b0, flagBank[4], 3'b0, flagBank[3], 3'b0, flagBank[2], 3'b0, flagBank[1], 3'b0, flagBank[0]}) :
				   iSW[11] ? wRegDispFPU  :
				   iSW[9]  ? wRegDispCOP0 : wRegDisp
);


//  Define o endereco inicial do PC
wire [31:0]	PCinicial;
assign 	PCinicial	= (iSW[8]? BEGINNING_BOOT : BEGINNING_TEXT);  		// Controle do Boot


// Barramento Principal
wire [31:0]	DAddress, DWriteData;
wire [31:0]	DReadData;
wire 		DWriteEnable, DReadEnable;
wire [3:0]	DByteEnable;

// Barramento de Instrucoes
wire [31:0]	IAddress, IWriteData;
wire [31:0]	IReadData;
wire 		IWriteEnable, IReadEnable;
wire [3:0]	IByteEnable;



// Interface Comum entre o processador e os mostradores
wire [4:0]	wRegDispSelect;
wire [31:0]	wPC, wRegDisp, wRegDispFPU, wRegDispCOP0, wOutput, wInstr, wDebug;		// NOTE: wDebug declarado, mas nunca atribuído. assign comentado? Sem driver nem valor inicial.
wire [7:0]	flagBank;
wire [17:0]	wSinaisControle;
wire [5:0]	wControlState;
wire [4:0]	wVGASelect;
wire [31:0]	wVGARead;



/* ********************************* CPU ************************************ */
CPU CPU0 (
	.iCLK(CLK),							// Clock real do Processador
	.iCLK50(iCLK_50),  					// Clock 50MHz fixo, usado so na FPU
	.iRST(Reset),
	.iInitialPC(PCinicial),

	// Sinais de monitoramento
	.wPC(wPC),
	.wInstr(wInstr),
	.wDebug(),
	.wRegDispSelect(wRegDispSelect),
	.wRegDisp(wRegDisp),
	.wRegDispFPU(wRegDispFPU),
	.wRegDispCOP0(wRegDispCOP0),
	.flagBank(flagBank),
	.wControlState(wControlState),
	.wControlSignals(wSinaisControle),
	.wVGASelect(wVGASelect),
	.wVGARead(wVGARead),

	// Barramento Dados
	.DwReadEnable(DReadEnable), .DwWriteEnable(DWriteEnable),
	.DwByteEnable(DByteEnable),
	.DwAddress(DAddress), .DwWriteData(DWriteData),.DwReadData(DReadData),

	// Barramento Instrucoes - Nao tem no multiciclo
	.IwReadEnable(IReadEnable), .IwWriteEnable(IWriteEnable),
	.IwByteEnable(IByteEnable),
	.IwAddress(IAddress), .IwWriteData(IWriteData), .IwReadData(IReadData),

	// Interrupcao
	.iPendingInterrupt(wPendingInterrupt)
);



/* ************************* Memoria RAM Interface ************************** */
`ifdef MULTICICLO 		// Multiciclo
Memory_Interface MEMORY(
	.iCLK(CLK), .iCLKMem(iCLK_50),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),

	.iSynthAddress(iSynthAddress),
	.oSynthNoteData(oSynthNoteData)
);
// assign 	DReadData	= (DAddress==BEGINNING_TEXT?32'hfefefefe:32'hzzzzzzzz);
`endif


`ifndef MULTICICLO  	// Uniciclo e Pipeline
DataMemory_Interface MEMDATA(
	.iCLK(CLK), .iCLKMem(iCLK_50),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),

	.iSynthAddress(iSynthAddress),
	.oSynthNoteData(oSynthNoteData)
);
// assign 	DReadData	= 32'hdededede;

CodeMemory_Interface MEMCODE(
	.iCLK(CLK), .iCLKMem(iCLK_50),
	// Barramento
	.wReadEnable(IReadEnable), .wWriteEnable(IWriteEnable),
	.wByteEnable(IByteEnable),
	.wAddress(IAddress), .wWriteData(IWriteData), .wReadData(IReadData)
);
`endif



/* ***************************** SRAM Interface ***************************** */
	SRAM_Interface SRAM0 (
	.iCLK(CLK), .iCLKMem(iCLK_50),
	.SRAM_DQ(SRAM_DQ),
	.oSRAM_A(oSRAM_A),
	.oSRAM_CLK(oSRAM_CLK),
	.oSRAM_GW_N(oSRAM_GW_N),
	.oSRAM_OE_N(oSRAM_OE_N),
	.oSRAM_WE_N(oSRAM_WE_N),
	.oSRAM_CE1_N(oSRAM_CE1_N),
	.oSRAM_CE2(oSRAM_CE2),
	.oSRAM_CE3_N(oSRAM_CE3_N),
	.oSRAM_BE_N(oSRAM_BE_N),
	.oSRAM_ADV_N(oSRAM_ADV_N),
	.oSRAM_ADSP_N(oSRAM_ADSP_N),
	.oSRAM_ADSC_N(oSRAM_ADSC_N),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData)
);

/* **************************** SRAM2 Interface ****************************
	SRAM2_Interface SRAM0 (
	.iCLK(CLK), .iCLKMem(iCLK_200),
	.SRAM_DQ(SRAM_DQ),
	.oSRAM_A(oSRAM_A),
	.oSRAM_CLK(oSRAM_CLK),
	.oSRAM_GW_N(oSRAM_GW_N),
	.oSRAM_OE_N(oSRAM_OE_N),
	.oSRAM_WE_N(oSRAM_WE_N),
	.oSRAM_CE1_N(oSRAM_CE1_N),
	.oSRAM_CE2(oSRAM_CE2),
	.oSRAM_CE3_N(oSRAM_CE3_N),
	.oSRAM_BE_N(oSRAM_BE_N),
	.oSRAM_ADV_N(oSRAM_ADV_N),
	.oSRAM_ADSP_N(oSRAM_ADSP_N),
	.oSRAM_ADSC_N(oSRAM_ADSC_N),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),
	// Barramento Sintetizador
	.wReadEnableS(DReadEnableS),
	.wAddressS(DAddressS), .wReadDataS(DReadDataS)
);
*/



/* ***************************** Interrupcoes ****************************** */
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire [7:0] 	wPendingInterrupt;
assign 	wPendingInterrupt	= {5'b0,
							(!reg_mouse_keyboard)&&(received_data_en_contador_enable) ,
							(audio_clock_flip_flop ^ audio_proc_clock_flip_flop),
							reg_mouse_keyboard&&(ps2_scan_ready_clock ^ keyboard_interrupt)
};



/* ********************* 7 segment displays Interface ********************** */
Display7_Interface DisplayI7 (.HEX0_D(oHEX0_D), .HEX1_D(oHEX1_D), .HEX2_D(oHEX2_D), .HEX3_D(oHEX3_D), .HEX4_D(oHEX4_D), .HEX5_D(oHEX5_D), .HEX6_D(oHEX6_D), .HEX7_D(oHEX7_D),
								.HEX0_DP(oHEX0_DP), .HEX1_DP(oHEX1_DP), .HEX2_DP(oHEX2_DP), .HEX3_DP(oHEX3_DP), .HEX4_DP(oHEX4_DP), .HEX5_DP(oHEX5_DP), .HEX6_DP(oHEX6_DP), .HEX7_DP(oHEX7_DP),
								.Output(wOutput)
);



/* ***************************** VGA Interface ****************************** */
VGA_Interface VGA0 (
	.CLK(CLK), .iCLK_50(iCLK_50), .iRST(Reset),
	.oVGA_CLOCK(oVGA_CLOCK), .oVGA_HS(oVGA_HS), .oVGA_VS(oVGA_VS), .oVGA_BLANK_N(oVGA_BLANK_N), .oVGA_SYNC_N(oVGA_SYNC_N),
	.oVGA_R(oVGA_R), .oVGA_G(oVGA_G), .oVGA_B(oVGA_B),
	.oVGASelect(wVGASelect),
	.iVGARead(wVGARead),
	.iDebugEnable(iSW[12]),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData)
);



/* ************************* Audio CODEC Interface ************************** */
wire 		audio_clock_flip_flop, audio_proc_clock_flip_flop;

AudioCODEC_Interface Audio0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .iCLK_50_2(iCLK_50_2), .Reset(Reset),
	.iCLK_28(iCLK_28),
	.oTD1_RESET_N(oTD1_RESET_N),
	.I2C_SDAT(I2C_SDAT),
	.oI2C_SCLK(oI2C_SCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.iAUD_ADCDAT(iAUD_ADCDAT),
	.AUD_DACLRCK(AUD_DACLRCK),
	.oAUD_DACDAT(oAUD_DACDAT),
	.AUD_BCLK(AUD_BCLK),
	.oAUD_XCK(oAUD_XCK),
	// Para o sintetizador
	.wsaudio_outL(wsaudio_outL),
	.wsaudio_outR(wsaudio_outR),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),
	// Interrupcao
	.audio_clock_flip_flop(audio_clock_flip_flop),
	.audio_proc_clock_flip_flop(audio_proc_clock_flip_flop)
);



/* ************************* Teclado PS2 Interface ************************** */
wire 		ps2_scan_ready_clock, keyboard_interrupt;

TecladoPS2_Interface TEC0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .Reset(Reset),
	.PS2_KBCLK(PS2_KBCLK),
	.PS2_KBDAT(PS2_KBDAT),
	// Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),
	//Interrupcao
	.ps2_scan_ready_clock(ps2_scan_ready_clock),
	.keyboard_interrupt(keyboard_interrupt)
);



/* ***************************** LCD Interface ****************************** */
LCD_Interface LCD0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .Reset(Reset),
	.LCD_D(LCD_D),			//	LCD Data bus 8 bits
	.oLCD_ON(oLCD_ON),		//	LCD Power ON/OFF
	.oLCD_BLON(oLCD_BLON),		//	LCD Back Light ON/OFF
	.oLCD_RW(oLCD_RW),		//	LCD Read/Write Select, 0 = Write, 1 = Read
	.oLCD_EN(oLCD_EN),		//	LCD Enable
	.oLCD_RS(oLCD_RS),		//	LCD Command/Data Select, 0 = Command, 1 = Data
	//  Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData)
);



/* ************************ Sintetizador Interface ************************* */
wire [15:0]	wsaudio_outL, wsaudio_outR;
wire 		DReadEnableS;
wire [31:0]	DAddressS, DReadDataS;
wire [31:0]	oSynthNoteData, iSynthAddress;

Sintetizador_Interface SINT0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .Reset(Reset),
	.AUD_DACLRCK(AUD_DACLRCK),
	.AUD_BCLK(AUD_BCLK),
	.wsaudio_outL(wsaudio_outL), .wsaudio_outR(wsaudio_outR),
	//  Barramento Principal
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),
	//  Barramento do Sintetizador
	.wReadEnableS(DReadEnableS),
	.wAddressS(DAddressS), .wReadDataS(DReadDataS),

	.iSynthAddress(iSynthAdress),								// NOTE: Declaração implícita de iSynthAdress
	.oSynthNoteData(oSynthNoteData)
);



/* **************************** Mouse Interface ***************************** */
wire 		reg_mouse_keyboard, received_data_en_contador_enable;

MousePS2_Interface MOUSE0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .Reset(Reset),
	.PS2_KBCLK(PS2_KBCLK),
 	.PS2_KBDAT(PS2_KBDAT),
	//  Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData),
	// Interrupcao
	.reg_mouse_keyboard(reg_mouse_keyboard),
	.received_data_en_contador_enable(received_data_en_contador_enable)
);



/* **************************** RS232 Interface ***************************** */
RS232_Interface SERIAL0 (
	.iCLK(CLK), .iCLK_50(iCLK_50), .Reset(Reset),
	.oUART_TXD(oUART_TXD),					//	UART Transmitter
	.iUART_RXD(iUART_RXD),					//	UART Receiver
	.oUART_CTS(oUART_CTS),		 			//	UART Clear To Send
	.iUART_RTS(iUART_RTS),					//	UART Request To Send
	//  Barramento
	.wReadEnable(DReadEnable), .wWriteEnable(DWriteEnable),
	.wByteEnable(DByteEnable),
	.wAddress(DAddress), .wWriteData(DWriteData), .wReadData(DReadData)
);



endmodule
