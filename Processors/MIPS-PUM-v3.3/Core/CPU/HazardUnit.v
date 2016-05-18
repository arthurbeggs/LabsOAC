/*
 * Unidade de Deteccao de Hazard
 */
 module HazardUnit (
	iID_NumRs,
	iID_NumRt, 
	iEX_NumRt, 
	iEX_MemRead, // op == load?
	iEX_RegWrite,
	iCJr, // opcode == jr?
	iEX_RegDestino,
	iMEM_MemRead,
	iMEM_RegDestino,
	iMEM_RegWrite,
	iBranch, // op == beq || bne?
	oBlockPC, 
	oBlockIFID,
	oFlushControl,
	oForwardJr,
	oForwardPC4
);
	input wire [4:0] iID_NumRs, iID_NumRt, iEX_NumRt, iEX_RegDestino, iMEM_RegDestino;
	input wire iEX_MemRead,iEX_RegWrite, iMEM_MemRead, iMEM_RegWrite, iCJr, iBranch;
	output reg oBlockPC, oBlockIFID, oFlushControl, oForwardJr, oForwardPC4;
	
	always @( * )
	begin
		// Hazard de dados
		// Bug em potencial: gerar bolha apos instrucoes que nao escrevem no registrador
    // Ex: beq $t1, $t0, LABEL1 e beq $t2, $t0, LABEL2 podem gerar bolha desnecessaria, pois $t0 eh considerado RegDestino (teria que arrumar em Control.v)
		if (
     // Condicao antiga. Nao funcionava porque em alguns casos o reg de destino era o rd, nao o rt
     // ( (iEX_MemRead || iBranch) && (iEX_NumRt != 5'b0) && ((iEX_NumRt == iID_NumRs) || (iEX_NumRt == iID_NumRt)) ) // EX (load) -> ID
		 
	/*	 Condicao antiga. Gerava bolhas para instruções que não escreviam no banco de registradores
   ( (iEX_MemRead || iBranch) && (iEX_RegDestino != 5'b0) && ((iEX_RegDestino == iID_NumRs) || (iEX_RegDestino == iID_NumRt)) ) // EX (load) -> ID && EX (ULA) -> ID
		 || ( iBranch && iMEM_MemRead && (iMEM_RegDestino != 5'b0) && ((iMEM_RegDestino == iID_NumRs) || (iMEM_RegDestino == iID_NumRt)) ) // MEM (load) -> ID
    // || ( iBranch && ((iEX_RegDestino == iIF_ID_NumRs) || (iEX_RegDestino == iIF_ID_NumRt)) ) // travando */
	 
   (  (iEX_MemRead || iBranch) && iEX_RegWrite && (iEX_RegDestino != 5'b0) && ((iEX_RegDestino == iID_NumRs) || (iEX_RegDestino == iID_NumRt)) ) // EX (load) -> ID && EX (ULA) -> ID
		 || ( iBranch && iMEM_MemRead && iMEM_RegWrite && (iMEM_RegDestino != 5'b0) && ((iMEM_RegDestino == iID_NumRs) || (iMEM_RegDestino == iID_NumRt)) ) // MEM (load) -> ID
		 
		)
		begin
			oBlockPC      = 1;
			oBlockIFID    = 1;
			oFlushControl = 1;
		end
		else begin
			oBlockPC      = 0;
			oBlockIFID    = 0;
			oFlushControl = 0;
		end
		
		// se op = jr e registrador estiver sendo atribuido em EX, faz forwarding da ALU
		oForwardJr = ((iCJr) && (iEX_RegDestino == iID_NumRs)) ? 1'b1 : 1'b0;
		
		oForwardPC4 = ((iCJr) && (iMEM_RegDestino == 5'd31)) ? 1'b1 : 1'b0;
	end
	
endmodule
