/*
add 4 bits ASSINCRONO
 */
 
module add4v (
input [3:0] iA, iB,
output [3:0] oSUM,
output oCARRY);




wire c0, c1, c2;

//somadores unarios em série
	//full_addv (input1, input2, carryIN, oSUM, carryOUT);
full_addv x1 (iA[0], iB[0], gnd, oSUM[0], c0);
full_addv x2 (iA[1], iB[1], c0, oSUM[1], c1);
full_addv x3 (iA[2], iB[2], c1, oSUM[2], c2);
full_addv x4 (iA[3], iB[3], c2, oSUM[3], oCARRY); 

endmodule
