/* teste_s.v */

/****************************************
*    UnB - OAC - Prof. Marcus Lamar      *
*    LaboratÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³rio 1  Parte B  - DE-2 70   *
*    GRUPO 2									  *
*	  SOMADOR A NIVEL DE PORTAS LOGICAS   *
*************************************** */

// Este deve ser o programa TOP LEVEL do projeto SINCRONO para execucao na placa DE2 70
// Ele recebe como entradas:
//			- as chaves iSW[3:0] como primeira parcela
// 		- as chaves iSW[17:14] como segunda parcela
// Ele tem como saiÃ‚Â­das:
// 		- o display de 7 segmentos HEX0 como valor da primeira parcela
// 		- o display de 7 segmentos HEX3 como valor da segunda parcela
// 		- o display de 7 segmentos HEX4 como valor da soma
// 		- o display de 7 segmentos HEX5 como valor do carry


module teste_s (
	input iCLK_50,
	input [17:0] iSW, 
	input [3:0] iKEY,
	output [17:0] oLEDR, 
	output [8:0] oLEDG,
	output [6:0] oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D,
	output oHEX0_DP, oHEX1_DP, oHEX2_DP, oHEX3_DP, oHEX4_DP, oHEX5_DP, oHEX6_DP, oHEX7_DP );
	
	wire [3:0]f1;
	wire f2;

	assign oLEDR = iSW;
	assign oLEDG[0] = iKEY[0];
	assign oLEDG[1] = ~iKEY[0];
	assign oLEDG[2] = iKEY[1];
	assign oLEDG[3] = ~iKEY[1];
	assign oLEDG[4] = iKEY[2];
	assign oLEDG[5] = ~iKEY[2];
	assign oLEDG[6] = iKEY[3];
	assign oLEDG[7] = ~iKEY[3];

	assign oHEX0_DP=1'b1;
	assign oHEX1_DP=1'b1;
	assign oHEX1_D=7'b1111111;
	assign oHEX2_DP=1'b1;
	assign oHEX2_D=7'b1111111;
	assign oHEX3_DP=1'b1;
	assign oHEX4_DP=1'b1;
	assign oHEX5_DP=1'b1;
	assign oHEX6_DP=1'b1;
	assign oHEX6_D=7'b1111111;
	assign oHEX7_DP=1'b1;
	assign oHEX7_D=7'b1111111;
	
	
	add4v_s a0 (.clock(iCLK_50), .iA(iSW[3:0]), .iB(iSW[17:14]), .oSUM(f1[3:0]), .oCARRY(f2));	//modulo somador
			
	decoder7_s t0 (.In(iSW[3:0]),  .Out(oHEX0_D), .clock(iCLK_50));
	decoder7_s t1 (.In(iSW[17:14]),  .Out(oHEX3_D), .clock(iCLK_50));
	decoder7_s t2 (.In(f1[3:0]), .Out(oHEX4_D), .clock(iCLK_50));
	show_carry_s s0 (.carry(f2), .display(oHEX5_D), .clock(iCLK_50));
	
endmodule

