/*
 * Unidade de Forward
 * 
 * iID_NumRs:       Numero do registrador rs no estagio ID
 * iID_NumRt:       Numero do registrador rt no estagio ID
 * iEX_NumRs:       Numero do registrador rs no estagio EX
 * iEX_NumRt:       Numero do registrador rt no estagio EX
 * iMEM_NumRd:      Numero do registrador rd no estagio MEM
 * iMEM_RegWrite:   Se a instrucao no estagio MEM escreve no banco de registradores
 * iWB_NumRd:       Numero do registrador rd no estagio WB
 * iWB_RegWrite:    Se a instrucao no estagio WB escreve no banco de registradores
 * iWB_MemRead:     Se a instrucao no estagio WB le da memoria
 * oFwdA/B:         Seletores de mux para as entradas A/B da ALU
 *                    10 - Forwarding MEM -> EX
 *                    01 - Forwarding WB -> EX
 *                    00 - Sem forwarding 
 * oFwdBranchRs/Rt: Seletores de mux para as entradas no calculo de branch (ID)
 * 
 */

module ForwardUnitM ( /*******ATUALIZAÇÃO LAB 5********/	
	iID_NumRs,
	iID_NumRt,
	iEX_NumRs, 
	iEX_NumRt, 
	iMEM_NumRd, 
	iMEM_RegWrite, 
	iWB_NumRd, 
	iWB_RegWrite,
	iWB_MemRead,
	iMEM_MovN, /*******INSERÇÃO LAB 5********/
	iMEM_MovZ, /*******INSERÇÃO LAB 5********/	
	iMEM_Zero, /*******INSERÇÃO LAB 5********/
	iWB_MovN, /*******INSERÇÃO LAB 5********/
	iWB_MovZ, /*******INSERÇÃO LAB 5********/	
	iWB_Zero, /*******INSERÇÃO LAB 5********/	
	iLock,
	oFwdA, 
	oFwdB,
	oFwdBranchRs,
	oFwdBranchRt
);

	input wire [4:0] iID_NumRs, iID_NumRt;
	input wire [4:0] iEX_NumRs, iEX_NumRt;
	input wire [4:0] iMEM_NumRd, iWB_NumRd;
	input wire iMEM_RegWrite, iWB_RegWrite, iWB_MemRead, iMEM_MovN, iMEM_MovZ, iMEM_Zero, iWB_MovN, iWB_MovZ, iWB_Zero; /*******ATUALIZAÇÃO LAB 5********/
	input wire iLock;
	output reg [1:0] oFwdA, oFwdB;
	output reg oFwdBranchRs, oFwdBranchRt;
	
	always @(*) begin
		// If MEM_NumRD == WB_NumRD, MEM has priority since it's more recent
		
		// rs /*******ATUALIZAÇÃO LAB 5*******/
		oFwdA = /*iLock? 2'b00 :*/ ((iMEM_RegWrite || iMEM_MovN || iMEM_MovZ) && (iMEM_NumRd != 5'b0) && (iMEM_NumRd == iEX_NumRs) && (((~iMEM_MovN) && (~iMEM_MovZ)) ||(iMEM_MovN && ~iMEM_Zero) || (iMEM_MovZ && iMEM_Zero))) ? 2'b10 // MEM -> EX
		    : ((iMEM_RegWrite || iMEM_MovN || iMEM_MovZ) && (iMEM_NumRd != 5'b0) && (iMEM_NumRd == iEX_NumRs) && ((iMEM_MovN && iMEM_Zero) || (iMEM_MovZ && ~iMEM_Zero)))? 2'b00 
			 : ((iWB_RegWrite) && (iWB_NumRd != 5'b0) && (iMEM_NumRd != iEX_NumRs) && (iWB_NumRd == iEX_NumRs)) ? 2'b01 // WB -> EX
          : 2'b00; // no forwarding
		
		// rt /*******ATUALIZAÇÃO LAB 5*******/
		oFwdB = /*iLock? 2'b00:*/((iMEM_RegWrite || iMEM_MovN || iMEM_MovZ) && (iMEM_NumRd != 5'b0) && (iMEM_NumRd == iEX_NumRt) && (((~iMEM_MovN) && (~iMEM_MovZ)) ||(iMEM_MovN && ~iMEM_Zero) || (iMEM_MovZ && iMEM_Zero))) ? 2'b10 // MEM -> EX
		    : ((iMEM_RegWrite || iMEM_MovN || iMEM_MovZ) && (iMEM_NumRd != 5'b0) && (iMEM_NumRd == iEX_NumRt) && ((iMEM_MovN && iMEM_Zero) || (iMEM_MovZ && ~iMEM_Zero)))? 2'b00 
			 : ((iWB_RegWrite) && (iWB_NumRd != 5'b0) && (iMEM_NumRd != iEX_NumRt) && (iWB_NumRd == iEX_NumRt)) ? 2'b01 // WB -> EX
          : 2'b00; // no forwarding
		
		
		// MEM -> ID (branch) /*******ATUALIZAÇÃO LAB 5*******/
		oFwdBranchRs = /*iLock? 1'b0 :*/ ( (iMEM_RegWrite || iMEM_MovN || iMEM_MovZ ) && (iID_NumRs != 5'b0) && (iMEM_NumRd == iID_NumRs) && (((~iMEM_MovN) && (~iMEM_MovZ)) || (iMEM_MovN && ~iMEM_Zero) || (iMEM_MovZ && iMEM_Zero))) ? 1'b1 : 1'b0;
		oFwdBranchRt = /*iLock? 1'b0 : */( (iMEM_RegWrite || iMEM_MovN || iMEM_MovZ) && (iID_NumRt != 5'b0) && (iMEM_NumRd == iID_NumRt) && (((~iMEM_MovN) && (~iMEM_MovZ)) || (iMEM_MovN && ~iMEM_Zero) || (iMEM_MovZ && iMEM_Zero))) ? 1'b1 : 1'b0;		
	end 
	
endmodule
