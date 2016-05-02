/* teste.v */

/****************************************
*    UnB - OAC - Prof. Marcus Lamar      *
*    Laboratório 1  Parte B  - DE-2 70   *
*    Exemplo 1                           *
*************************************** */

// Este exemplo visa apresentar as facilidades de IO
// da plataforma de desenvolvimento Altera - DE2 70


module teste23 (
	//input iCLK_50,
	input [7:0] iSW, 
	//input [3:0] iKEY,
	output [7:0] oLEDR, 
	//output [8:0] oLEDG,
	//output [6:0] oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D,
	//output oHEX0_DP, oHEX1_DP, oHEX2_DP, oHEX3_DP );
	output [6:0] oHEX0_D ,
	output [3:0] sum 
	);
	wire cIn;

	assign oLEDR = iSW;
	//assign oLEDG[0] = iKEY[0];
	//assign oLEDG[1] = ~iKEY[0];
	//assign oLEDG[2] = iKEY[1];
	//assign oLEDG[3] = ~iKEY[1];
	//assign oLEDG[4] = iKEY[2];
	//assign oLEDG[5] = ~iKEY[2];

	//assign oHEX0_DP=1'b1;
	//assign oHEX1_DP=1'b1;
	//assign oHEX2_DP=1'b1;
	//assign oHEX3_DP=1'b1;

	//xor x1 (oLEDG[6],iSW[17],iSW[16]); // Exemplo de uso de porta lógica
	//assign oLEDG[7]=iSW[17]^iSW[16];
	add4cv x1 (sum[3:0], iSW[3:0], iSW[7:4], cIn);	
	//decoder7 u0 (.In(iSW[3:0]),  .Out(oHEX0_D), .Clk(iCLK_50));
	//decoder7 u1 (.In(iSW[7:4]),  .Out(oHEX1_D), .Clk(iCLK_50));
	//decoder7 u2 (.In(iSW[11:8]), .Out(oHEX2_D), .Clk(iCLK_50));
	//decoder7 u3 (.In(iSW[15:12]),.Out(oHEX3_D), .Clk(iCLK_50));
	decoder7 u0 (sum[3:0], oHEX0_D[6:0]);
endmodule
