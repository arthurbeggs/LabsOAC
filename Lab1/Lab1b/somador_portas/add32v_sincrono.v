/*
add 32 bits SINCRONO
 */
 
module add32v_sincrono (
input clock,
input [31:0] iA, iB,
output [31:0] oSUM,
output oCARRY);




wire [30:0] fio;
reg [31:0] fA, fB;

//somadores binarios em serie
	//full_addv (clock, input1, input2, carryIN, oSUM, carryOUT);
always @ (posedge clock)
	begin
		fA = iA;
		fB = iB;
	end
	

full_addv x01 (fA[0], fB[0], gnd, oSUM[0], fio[0]);
full_addv x02 (fA[1], fB[1], fio[0], oSUM[1], fio[1]);
full_addv x03 (fA[2], fB[2], fio[1], oSUM[2], fio[2]);
full_addv x04 (fA[3], fB[3], fio[2], oSUM[3], fio[3]);
full_addv x05 (fA[4], fB[4], fio[3], oSUM[4], fio[4]);
full_addv x06 (fA[5], fB[5], fio[4], oSUM[5], fio[5]);
full_addv x07 (fA[6], fB[6], fio[5], oSUM[6], fio[6]);
full_addv x08 (fA[7], fB[7], fio[6], oSUM[7], fio[7]);
full_addv x09 (fA[8], fB[8], fio[7], oSUM[8], fio[8]);
full_addv x10 (fA[9], fB[9], fio[8], oSUM[9], fio[9]);
full_addv x11 (fA[10], fB[10], fio[9], oSUM[10], fio[10]);
full_addv x12 (fA[11], fB[11], fio[10], oSUM[11], fio[11]);
full_addv x13 (fA[12], fB[12], fio[11], oSUM[12], fio[12]);
full_addv x14 (fA[13], fB[13], fio[12], oSUM[13], fio[13]);
full_addv x15 (fA[14], fB[14], fio[13], oSUM[14], fio[14]);
full_addv x16 (fA[15], fB[15], fio[14], oSUM[15], fio[15]);
full_addv x17 (fA[16], fB[16], fio[15], oSUM[16], fio[16]);
full_addv x18 (fA[17], fB[17], fio[16], oSUM[17], fio[17]);
full_addv x19 (fA[18], fB[18], fio[17], oSUM[18], fio[18]);
full_addv x20 (fA[19], fB[19], fio[18], oSUM[19], fio[19]);
full_addv x21 (fA[20], fB[20], fio[19], oSUM[20], fio[20]);
full_addv x22 (fA[21], fB[21], fio[20], oSUM[21], fio[21]);
full_addv x23 (fA[22], fB[22], fio[21], oSUM[22], fio[22]);
full_addv x24 (fA[23], fB[23], fio[22], oSUM[23], fio[23]);
full_addv x25 (fA[24], fB[24], fio[23], oSUM[24], fio[24]);
full_addv x26 (fA[25], fB[25], fio[24], oSUM[25], fio[25]);
full_addv x27 (fA[26], fB[26], fio[25], oSUM[26], fio[26]);
full_addv x28 (fA[27], fB[27], fio[26], oSUM[27], fio[27]);
full_addv x29 (fA[28], fB[28], fio[27], oSUM[28], fio[28]);
full_addv x30 (fA[29], fB[29], fio[28], oSUM[29], fio[29]);
full_addv x31 (fA[30], fB[30], fio[29], oSUM[30], fio[30]);
full_addv x32 (fA[31], fB[31], fio[30], oSUM[31], oCARRY);


endmodule
