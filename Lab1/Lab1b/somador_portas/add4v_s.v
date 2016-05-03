/*
add 4 bits SINCRONO
 */
 
module add4v_s (
input clock,
input wire [3:0] iA, iB,
output [3:0] oSUM,
output oCARRY);


wire c0, c1, c2;
reg [31:0] fA, fB;

//somadores binarios em serie
	//full_addv (clock, input1, input2, carryIN, oSUM, carryOUT);
always @ (posedge clock)
	begin
		fA = iA;
		fB = iB;
	end
	
	
full_addv x1 (fA[0], fB[0], gnd, oSUM[0], c0);
full_addv x2 (fA[1], fB[1], c0, oSUM[1], c1);
full_addv x3 (fA[2], fB[2], c1, oSUM[2], c2);
full_addv x4 (fA[3], fB[3], c2, oSUM[3], oCARRY);

endmodule
