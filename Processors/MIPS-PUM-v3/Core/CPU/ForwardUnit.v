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

module ForwardUnit (
	iID_NumRs,
	iID_NumRt,
	iEX_NumRs, 
	iEX_NumRt, 
	iMEM_NumRd, 
	iMEM_RegWrite, 
	iWB_NumRd, 
	iWB_RegWrite,
	iWB_MemRead,
	oFwdA, 
	oFwdB,
	oFwdBranchRs,
	oFwdBranchRt
);
	input wire [4:0] iID_NumRs, iID_NumRt;
	input wire [4:0] iEX_NumRs, iEX_NumRt;
	input wire [4:0] iMEM_NumRd, iWB_NumRd;
	input wire iMEM_RegWrite, iWB_RegWrite, iWB_MemRead;
	output reg [1:0] oFwdA, oFwdB;
	output reg oFwdBranchRs, oFwdBranchRt;
	
	always @( * )
	begin
		// Se MEM_NumRD == WB_NumRD, MEM tem prioridade por ser mais recente
		if(iEX_NumRs!=0)
		// rs
		oFwdA = ((iMEM_RegWrite) && (iMEM_NumRd != 0) && (iMEM_NumRd == iEX_NumRs)) ? 2'b10 // MEM -> EX
		  : ((iWB_RegWrite) && (iWB_NumRd != 0) && (iMEM_NumRd != iEX_NumRs) && (iWB_NumRd == iEX_NumRs)) ? 2'b01 // WB -> EX
          : 2'b00; // sem forwarding
		else
			oFwdA = 2'b00;
		
		if(iEX_NumRt!=0)
		// rt
		oFwdB = ((iMEM_RegWrite) && (iMEM_NumRd != 0) && (iMEM_NumRd == iEX_NumRt)) ? 2'b10 // MEM -> WB
          : ((iWB_RegWrite) && (iWB_NumRd != 0) && (iMEM_NumRd != iEX_NumRt) && (iWB_NumRd == iEX_NumRt)) ? 2'b01 // WB -> EX
          : 2'b00; // sem forwarding
          else
			oFwdB = 2'b00;
		
		// MEM -> ID (branch)
		//Retirado, pois tomava valores de instruções que sequer escreviam no banco de regs para escrevê-las em ID_RS e ID_RT
		//oFwdBranchRs = (!iWB_MemRead && (iID_NumRs != 0) && (iMEM_NumRd == iID_NumRs)) ? 1'b1 : 1'b0;
		//oFwdBranchRt = (!iWB_MemRead && (iID_NumRt != 0) && (iMEM_NumRd == iID_NumRt)) ? 1'b1 : 1'b0;
		oFwdBranchRs = ( iMEM_RegWrite && (iID_NumRs != 0) && (iMEM_NumRd == iID_NumRs)) ? 1'b1 : 1'b0;
		oFwdBranchRt = ( iMEM_RegWrite && (iID_NumRt != 0) && (iMEM_NumRd == iID_NumRt)) ? 1'b1 : 1'b0;		
	end 
	
endmodule
