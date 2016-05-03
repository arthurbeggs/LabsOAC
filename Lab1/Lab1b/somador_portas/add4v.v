/*
add 8 bits
 */
 
module add4v (
input [3:0] iA, iB,
output [3:0] oSUM,
output oCARRY);




wire c0, c1, c2; //, c3, c4, c5 ,c6;

//somadores unarios em série
	//full_addv (input1, input2, carryIN, oSUM, carryOUT);
full_addv x1 (iA[0], iB[0], gnd, oSUM[0], c0);
full_addv x2 (iA[1], iB[1], c0, oSUM[1], c1);
full_addv x3 (iA[2], iB[2], c1, oSUM[2], c2);
full_addv x4 (iA[3], iB[3], c2, oSUM[3], oCARRY); //full_addv x4 (iA[3], iB[3], c2, oSUM[3], c3);
//full_addv x5 (iA[4], iB[4], c3, oSUM[4], c4);
//full_addv x6 (iA[5], iB[5], c4, oSUM[5], c5);
//full_addv x7 (iA[6], iB[6], c5, oSUM[6], c6);
//full_addv x8 (iA[7], iB[7], c6, oSUM[7], oCARRY);

endmodule
