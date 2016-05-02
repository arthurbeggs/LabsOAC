/* Parametros Gerais*/
parameter ON = 1'b1,
		  OFF = 1'b0,
		  ZERO = 32'h0,
		  
/* Operacoes da ULA */
			OPAND		= 5'b00000,	//0
			OPOR		= 5'b00001,	//1
			OPADD		= 5'b00010,	//2
			OPMFHI	= 5'b00011,	//3
			OPSLL		= 5'b00100,	//4
			OPMFLO	= 5'b00101,	//5
			OPSUB		= 5'b00110,	//6
			OPSLT		= 5'b00111,	//7
			OPSRL		= 5'b01000,	//8
			OPSRA		= 5'b01001,	//9
			OPXOR		= 5'b01010,	//10
			OPSLTU 	= 5'b01011,	//11
			OPNOR		= 5'b01100,	//12
			OPMULT	= 5'b01101,	//13
			OPDIV		= 5'b01110,	//14
			OPLUI		= 5'b01111,	//15
			OPSLLV	= 5'b10000,	//16
			OPSRAV	= 5'b10001,	//17
			OPSRLV	= 5'b10010,	//18
			OPMULTU 	= 5'b10011, //19
			OPDIVU  	= 5'b10100, //20
			// 2015/1
			OPMTHI 	= 5'b10101,	//21
			// 2015/1
			OPMTLO 	= 5'b10110,	//22
/* Operacoes da ULA FP */
			OPADDS	= 4'b0001,
			OPSUBS	= 4'b0010,
			OPMULS  	= 4'b0011,
			OPDIVS  	= 4'b0100,
			OPSQRT  	= 4'b0101,
			OPABS		= 4'b0110,
			OPNEG		= 4'b0111,
			OPCEQ		= 4'b1000,
			OPCLT		= 4'b1001,
			OPCLE		= 4'b1010,
			OPCVTSW	= 4'b1011,
			OPCVTWS	= 4'b1100,
			
			
/* Campo FUNCT */
			FUNSLL	= 6'h00,
			FUNSRL	= 6'h02,
			FUNSRA	= 6'h03,
			FUNJR		= 6'h08,
			FUNSYS	= 6'h0C,
			FUNMFHI	= 6'h10,
			// 2015/1
			FUNMTHI 	= 6'h11,
			FUNMFLO	= 6'h12,
			// 2015/1
			FUNMTLO 	= 6'h13,
			FUNMULT	= 6'h18,
			FUNMULTU	= 6'h19,
			FUNDIV 	= 6'h1A,
			FUNDIVU  = 6'h1B,
			FUNADD	= 6'h20,
			FUNADDU 	= 6'h21,
			FUNSUB	= 6'h22,
			FUNSUBU 	= 6'h23,
			FUNAND	= 6'h24,
			FUNOR		= 6'h25,
			FUNXOR	= 6'h26,
			FUNNOR	= 6'h27,
			FUNSLT	= 6'h2A,
			FUNSLTU 	= 6'h2B,
			FUNSLLV 	= 6'h04,
			FUNSRLV 	= 6'b000110,
			FUNSRAV 	= 6'b000111,
			/*Abaixo FUNCT de operacoes em ponto flutuante*/
			FUNADDS 	= 6'h0,
			FUNSUBS 	= 6'h1,
			FUNMULS 	= 6'h2,
			FUNDIVS 	= 6'h3,
			FUNSQRT 	= 6'h4,
			FUNABS  	= 6'h5,
			FUNMOV	= 6'h6,
			FUNNEG  	= 6'h7,
			FUNCEQ  	= 6'h32,
			FUNCLT  	= 6'h3c,
			FUNCLE  	= 6'h3e,
			FUNCVTSW	= 6'h20,
			FUNCVTWS = 6'h24,
			FUNERET	= 6'h18,	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
			
/* Campo OPCODE */
			OPCRFMT	= 6'h00, /* Tipo-R */
			OPCJMP	= 6'h02,
			OPCJAL	= 6'h03,
			OPCBEQ	= 6'h04,
			OPCBNE	= 6'h05,
			OPCADDI 	= 6'h08,
			OPCADDIU = 6'h09,
			OPCSLTI	= 6'h0A,
			OPCSLTIU = 6'h0B,
			OPCANDI	= 6'h0C,
			OPCORI	= 6'h0D,
			OPCXORI	= 6'h0E,
			OPCLUI	= 6'h0F,
			OPCCOP0	= 6'h10, // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
			OPCFLT	= 6'h11, /*OPCODE para operacoes da FPU*/
			OPCLW		= 6'h23,
			OPCLB		= 6'h20,
			OPCLBU	= 6'h24,
			OPCLH		= 6'h21,
			OPCLHU	= 6'h25,
			OPCSW		= 6'h2B,
			OPCSB		= 6'h28,
			OPCSH		= 6'h29,
			OPCLWC1	= 6'h31,
			OPCSWC1	= 6'h39,
	
/* Campo FMT */
			FMTS 		= 5'h10,
			FMTW		= 5'h14,
			FMTBC1 	= 5'h8,
			FMTMFC	= 5'h0,
			FMTMTC	= 5'h4,
			FMTERET 	= 5'h10,	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
			
/* Bit 16 da instrucao, usado somente para BC1 da FPU*/

			FTTRUE	= 1'b1,
			FTFALSE	= 1'b0,
			
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)

		EXCODEINT	= 5'd0,
		EXCODESYS	= 5'd8,
		EXCODEINSTR = 5'd10,
		EXCODEALU	= 5'd12,
		EXCODEFPALU	= 5'd15,

			
/* SYSCALL operations *************************************************************************************************/
		SYSPRTINT	= 6'd1,	//1
		SYSPRTSTR	= 6'd4,	//4
		SYSPRTCHR	= 6'd11,	//11			
		SYSTIME		= 6'd30,	//30
		SYSSLEEP		= 6'd32,	//32
		SYSRNDINT	= 6'd41,	//41
	
	
/* ADDRESS MACROS *****************************************************************************************************/

BACKGROUND_IMAGE	= "display.mif",


	BEGINNING_TEXT	= 32'h00400000,
	END_TEXT			= 32'h00403FFF,
	
	BEGINNING_BOOT	= 32'h00000000,
	END_BOOT 		= 32'h000000FF,
	
	BEGINNING_DATA	= 32'h10010000,
	END_DATA			= 32'h10011FFF,
	
	BEGINNING_SRAM	= 32'h10012000,
	END_SRAM			= 32'h10211FFF,
	//STACK_ADDRESS	= 32'h10011ffc,  // Colocar Para Simulacao forma de onda do MIPS que nao tem SRAM
	STACK_ADDRESS	= 32'h10211FFC,  // Para DE2 que tem  SRAM
	
	BEGINNING_KTEXT	= 32'h80000000,
	END_KTEXT			= 32'h80001FFF,
	
	BEGINNING_KDATA	= 32'h90000000,
	END_KDATA			= 32'h90000FFF,	
	
	BEGINNING_IODEVICES			= 32'hFF000000,
		BEGINNING_VGA				= 32'hFF000000,
		END_VGA						= 32'hFF012C00,
	
		AUDIO_INL_ADDRESS			= 32'hFFFF0000,
		AUDIO_INR_ADDRESS			= 32'hFFFF0004,
		AUDIO_OUTL_ADDRESS		= 32'hFFFF0008,
		AUDIO_OUTR_ADDRESS		= 32'hFFFF000C,
		AUDIO_CTRL1_ADDRESS		= 32'hFFFF0010,
		AUDIO_CRTL2_ADDRESS		= 32'hFFFF0014,
	
		BUFFER0_TECLADO_ADDRESS	= 32'hFFFF0100,
		BUFFER1_TECLADO_ADDRESS	= 32'hFFFF0104,
	
		TECLADOxMOUSE_ADDRESS	= 32'hFFFF0110,
		BUFFERMOUSE_ADDRESS		= 32'hFFFF0114,
	
		RS232_READ_ADDRESS 		= 32'hFFFF0120,
		RS232_WRITE_ADDRESS 		= 32'hFFFF0121,
		RS232_CONTROL_ADDRESS 	= 32'hFFFF0122,
	
		BEGINNING_LCD				= 32'hFFFF0130,
		SECOND_LINE_LCD			= 32'hFFFF0140,
		END_LCD						= 32'hFFFF014F,
		LCD_CLEAR_ADDRESS			= 32'hFFFF0150,
		
		//SYSCALL NOTE ADDRESS
		NOTE_SYSCALL_ADDRESS		= 32'hFFFF0200,
		NOTE_CLOCK 					= 32'hFFFF0204,
		NOTE_MELODY 				= 32'hFFFF0208,
		MUSIC_TEMPO_ADDRESS		= 32'hFFFF020C,
		MUSIC_ADDRESS 				= 32'hFFFF0210,		// Endereco para uso do Controlador do sintetizador
		
		
/* STATES ************************************************************************************************************/
	FETCH			= 6'd0,
	DECODE		= 6'd1,
	LWSW			= 6'd2,
	LW				= 6'd3,
	LW2			= 6'd4,
	SW				= 6'd5,
	RFMT			= 6'd6,
	RFMT2			= 6'd7,
	SHIFT			= 6'd8,
	IFMTL			= 6'd9,
	IFMTA			= 6'd10,
	IFMT2			= 6'd11,
	BEQ			= 6'd12,
	BNE			= 6'd13,
	JUMP			= 6'd14,
	JAL			= 6'd15,
	JR				= 6'd16,
			
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	COP0MTC0		= 6'd17,
	COP0MFC0		= 6'd18,
	COP0ERET		= 6'd19,
	COP0EXC		= 6'd20,
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
			
	//PRINT		= 6'd32,
	TIME			= 6'd33,
	TIME2			= 6'd34,
	SLEEP			= 6'd35,
	SLEEP2		= 6'd36,
	RANDOM		= 6'd37,
	/*Estados da FPU*/
	FPUFR			= 6'd38,
	FPUFR2		= 6'd39,
	FPUMOV		= 6'd40,
	FPUMFC1		= 6'd41,
	FPUMTC1		= 6'd42,
	FPUBC1T		= 6'd43,
	FPUBC1F		= 6'd44,
	FPULWC1		= 6'd45,
	FPUSWC1		= 6'd46,
	FPUCOMP 		= 6'd48,		//tava assim, vou manter em homenagem aos semestres anteriores		
//	JOY			= 6'd38,
//	JRCLR			= 6'd39;
	ERRO			= 6'd63,
			
	//Adicionados em 1/2014
	STATE_LB 	= 6'd49,
	STATE_LBU 	= 6'd50,
	STATE_LH 	= 6'd51,
	STATE_LHU	= 6'd52,
	STATE_SB		= 6'd53,
	STATE_SH		= 6'd54;

		
		