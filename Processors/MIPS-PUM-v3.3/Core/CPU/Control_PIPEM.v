/*
 * Controle do Pipeline
 * DETALHE: ESTOU USANDO MAIS SINAIS DE 1 BIT para simplificar o entendimento, mas talvez seja mais rapido juntar alguns desses sinais como o OrigPc.. Ja mudei um pouco isso!
 * A marcacao (pra nada) indica que a escolha feita nao tem justificativa, tal escolha nao afeta em nada a execucao da instrucao

	oRegDst: registrador de destino
		00 - rt
		01 - rd
		10 - $ra
	oOrigALU:
		00 - 
		01 - 
		10 - 
		11 - 
	oMemparaReg
	oEscreveReg
	oLeMem: indica leitura da memoria (lw)
	oEscreveMem: indica escrita na memoria (sw)
	oOpALU
		00 - add
		01 - sub
		10 - campo funct
		11 - campo opcode
	oOrigPC
	oJump
	oBranch
	onBranch
	oJr: indica operacao jr
 */
module Control_PIPEM (	/********ATUALIZAÇÃO LAB 5*******/
	iOp, //OK
	iFunct, //OK
	oRegDst, //OK
	oOrigALU, //OK
	oSavePC, //OK
	oEscreveReg, //OK
	oLeMem, //OK
	oEscreveMem, //OK
	oOpALU, //OK
	oOrigPC, //OK
	oJump, //OK
	oBranch, //OK
	onBranch,
	oJr, //OK
	oLoadType,
	oWriteType,
	oMovN,                /********INSERÇÃO LAB 5*******/
	oMovZ                 /********INSERÇÃO LAB 5*******/
);

input wire [5:0] iOp, iFunct;
output reg oEscreveReg, oLeMem, oEscreveMem, oJump, oBranch, onBranch, oJr, oSavePC, oMovN, oMovZ; /********ATUALIZAÇÃO LAB 5*******/
output reg [1:0] oOpALU, oOrigALU, oRegDst;
output reg [2:0] oOrigPC;
output reg [2:0] oLoadType;
output reg [1:0] oWriteType;

always @(iOp, iFunct) begin
	case(iOp)
		OPCLW://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da memoria de dados
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b1;   // ativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = LOAD_TYPE_LW; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCLH:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b1;   // ativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = LOAD_TYPE_LH; // load signed halfword
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCLHU:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b1;   // ativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = LOAD_TYPE_LHU; // load unsigned halfword
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCLB:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b1;   // ativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = LOAD_TYPE_LB; // load signed byte
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCLBU:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b1;   // ativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = LOAD_TYPE_LBU; // byte unsigned
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCSW://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b1;   // ativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = STORE_TYPE_SW;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCSH:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b1;   // ativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = STORE_TYPE_SH;  // store halfword
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCSB:
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b1;   // ativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // realiza ADD
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = STORE_TYPE_SB;  // store byte
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCBEQ://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    = 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b001; // seleciona o endereco do branch
				oOpALU      = 2'b01;  // seleciona subtracao (pra nada)
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b1;   // ativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCBNE://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    = 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b101; // seleciona o endereco do branch
				oOpALU      = 2'b01;  // seleciona subtracao (pra nada)
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b1;   // ativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCRFMT:
			begin
				case (iFunct)
				FUNJR://OK
					begin
						oRegDst     = 2'b00;  // seleciona o Rt (pra nada)
						oOrigALU    = 2'b00;  // seleciona o resultado do fowardB (pra nada)
						oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
						oEscreveReg = 1'b0;   // desativa EscreveReg
						oLeMem      = 1'b0;   // desativa LeMem
						oEscreveMem = 1'b0;   // desativa EscreveMem
						oOrigPC     = 3'b010; // seleciona resultado do MUX Jr
						oOpALU      = 2'b10;  // seleciona campo funct
						oJump       = 1'b1;   // ativa jump (mesmo que um jr nao seja tipo J)
						oBranch     = 1'b0;   // desativa branch
						onBranch    = 1'b0;   // desativa BNE
						oJr         = 1'b1;   // ativa o Jr
						oLoadType   = 3'b000; // load word/ignore
						oWriteType  = 2'b00;  // write word/ignore
						oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
						oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
					end
				FUNSYS:
					begin
						oRegDst     = 2'b10;  // salva em $ra o end de retorno
						oOrigALU    = 2'b00;
						oSavePC     = 1'b1; // Escreve PC + 4
						oEscreveReg = 1'b1;
						oLeMem      = 1'b0;
						oEscreveMem = 1'b0;
						oOrigPC     = 3'b100; // Endereco do .ktext
						oOpALU      = 2'b10;
						oJump       = 1'b1;   // ativa jump (mesmo que um syscall nao seja tipo J)
						oBranch     = 1'b0;   // desativa branch
						onBranch    = 1'b0;   // desativa BNE
						oJr         = 1'b0;   // desativa o Jr
						oLoadType   = 3'b000; // load word/ignore
						oWriteType  = 2'b00;  // write word/ignore
						oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
						oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
					end
				/********INSERÇÃO LAB 5*******/	
				FUNMOVZ:
					begin
						oRegDst     = 2'b01;  // Registrador de destino das operações Movs é Rd
						oOrigALU    = 2'b00;	 // A segunda entrada da ULA é 
						oSavePC     = 1'b0;   // Escreve PC + 4
						oEscreveReg = 1'b0;	 // Escrevemos no banco de registadores
						oLeMem      = 1'b0;   // Não é feita a leitura da memória
						oEscreveMem = 1'b0;   // Não é feita a escrita na memória
						oOrigPC     = 3'b000; // PC + 4
						oOpALU      = 2'b01;  // Forçamos uma subtração
						oJump       = 1'b0;   // Não ativa o jump
						oBranch     = 1'b0;   // Desativa branch
						onBranch    = 1'b0;   // Desativa BNE
						oJr         = 1'b0;   // Desativa o Jr
						oLoadType   = 3'b000; // load word/ignore
						oWriteType  = 2'b00;  // write word/ignore
						oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
						oMovZ       = 1'b1;   /********INSERÇÃO LAB 5*******/
					end
				/********INSERÇÃO LAB 5*******/
				FUNMOVN:
					begin
						oRegDst     = 2'b01;  // Registrador de destino das operações Movs é Rd
						oOrigALU    = 2'b00;	 // A segunda entrada da ULA é ForwardB
						oSavePC     = 1'b0;   // Escreve PC + 4
						oEscreveReg = 1'b0;	 // Escrevemos no banco de registadores mas não por aqui
						oLeMem      = 1'b0;   // Não é feita a leitura da memória
						oEscreveMem = 1'b0;   // Não é feita a escrita na memória
						oOrigPC     = 3'b000; // PC + 4
						oOpALU      = 2'b01;  // Forçamos uma subtração
						oJump       = 1'b0;   // Não ativa o jump
						oBranch     = 1'b0;   // Desativa branch
						onBranch    = 1'b0;   // Desativa BNE
						oJr         = 1'b0;   // Desativa o Jr
						oLoadType   = 3'b000; // load word/ignore
						oWriteType  = 2'b00;  // write word/ignore
						oMovN       = 1'b1;   /********INSERÇÃO LAB 5*******/
						oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
					end
				//TIPO R
				default://OK
					begin
						oRegDst     = 2'b01;  // seleciona o Rd
						oOrigALU    = 2'b00;  // seleciona o resultado do fowardB
						oSavePC     = 1'b0;   // seleciona o resultado da ALU
						oEscreveReg = 1'b1;   // ativa EscreveReg
						oLeMem      = 1'b0;   // desativa LeMem
						oEscreveMem = 1'b0;   // desativa EscreveMem
						oOrigPC     = 3'b000; // seleciona PC+4
						oOpALU      = 2'b10;  // funct determina a operacao da ALU
						oJump       = 1'b0;   // desativa jump
						oBranch     = 1'b0;   // desativa branch
						onBranch    = 1'b0;   // desativa BNE
						oJr         = 1'b0;   // desativa o Jr
						oLoadType   = 3'b000; // load word/ignore
						oWriteType  = 2'b00;  // write word/ignore
						oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
						oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
					end
				endcase
			end
		OPCJMP://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt (pra nada)
				oOrigALU    = 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     = 1'b0;   // seleciona o resultado da MD (pra nada)
				oEscreveReg = 1'b0;   // desativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b010; // seleciona resultado do MUX Jr
				oOpALU      = 2'b00;  // seleciona ADD (pra nada)
				oJump       = 1'b1;   // ativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCADDI,
		OPCADDIU://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato com extensao de sinal
				oSavePC     = 1'b0;   // seleciona o resultado da ALU
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // opcode determina operacao da ALU
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCANDI://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     = 1'b0;   // seleciona o resultado da ALU
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // opcode determina operacao da ALU
				oJump       = 1'b0;   // desxativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCXORI://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     = 1'b0;   // seleciona o resultado da ALU
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // opcode determina operacao da ALU
				oJump       = 1'b0;   // desxativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCORI://OK
			begin
				oRegDst     = 2'b00;  // seleciona o Rt
				oOrigALU    = 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     = 1'b0;   // seleciona o resultado da ALU
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // opcode determina operacao da ALU
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCJAL://OK
			begin
				oRegDst     = 2'b10;  // Seleciona 31 (ra)
				oOrigALU    = 2'b00;  // seleciona o resultado do fowardB (pra nada)
				oSavePC     = 1'b1;   // Escreve PC + 4
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b010; // seleciona o resultado do MUX Jr
				oOpALU      = 2'b00;  // seleciona ADD (pra nada)
				oJump       = 1'b1;   // ativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCLUI://OK
			begin
				oRegDst     = 2'b00;  // Seleciona o Rt
				oOrigALU    = 2'b11;  // seleciona o imediato concatenado com 16 zeros
				oSavePC     = 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b00;  // seleciona ADD (pra nada)
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCSLTI:
			begin
				oRegDst     = 2'b00;  // Seleciona o Rt
				oOrigALU    = 2'b01;  // seleciona o imediato com extensao de sinal
				oSavePC     = 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // seleciona ADD (pra nada)
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		OPCSLTIU:
			begin
				oRegDst     = 2'b00;  // Seleciona o Rt
				oOrigALU    = 2'b10;  // seleciona o imediato com extensao com zeros
				oSavePC     = 1'b0;   // seleciona o resultado da ALU (antes selecionava Imm)
				oEscreveReg = 1'b1;   // ativa EscreveReg
				oLeMem      = 1'b0;   // desativa LeMem
				oEscreveMem = 1'b0;   // desativa EscreveMem
				oOrigPC     = 3'b000; // seleciona PC+4
				oOpALU      = 2'b11;  // seleciona ADD (pra nada)
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
		default: // Instrucao Nao reconhecida
			begin
				oRegDst     = 2'b00;
				oOrigALU    = 2'b00;
				oSavePC     = 1'b0;
				oEscreveReg = 1'b0;
				oLeMem      = 1'b0;
				oEscreveMem = 1'b0;
				oOrigPC     = 3'b111; // loop inf
				oOpALU      = 2'b00;
				oJump       = 1'b0;   // desativa jump
				oBranch     = 1'b0;   // desativa branch
				onBranch    = 1'b0;   // desativa BNE
				oJr         = 1'b0;   // desativa o Jr
				oLoadType   = 3'b000; // load word/ignore
				oWriteType  = 2'b00;  // write word/ignore
				oMovN       = 1'b0;   /********INSERÇÃO LAB 5*******/
				oMovZ       = 1'b0;   /********INSERÇÃO LAB 5*******/
			end
	endcase
end

endmodule
