/*
add 32 bits ASSINCRONO
 */
 
module add32v (
input [31:0] iA, iB,
output [31:0] oSUM,
output oCARRY);




wire [30:0] fio;

//somadores unarios em sÃ©rie
	//full_addv (input1, input2, carryIN, oSUM, carryOUT);
full_addv x01 (iA[0], iB[0], gnd, oSUM[0], fio[0]);
full_addv x02 (iA[1], iB[1], fio[0], oSUM[1], fio[1]);
full_addv x03 (iA[2], iB[2], fio[1], oSUM[2], fio[2]);
full_addv x04 (iA[3], iB[3], fio[2], oSUM[3], fio[3]);
full_addv x05 (iA[4], iB[4], fio[3], oSUM[4], fio[4]);
full_addv x06 (iA[5], iB[5], fio[4], oSUM[5], fio[5]);
full_addv x07 (iA[6], iB[6], fio[5], oSUM[6], fio[6]);
full_addv x08 (iA[7], iB[7], fio[6], oSUM[7], fio[7]);
full_addv x09 (iA[8], iB[8], fio[7], oSUM[8], fio[8]);
full_addv x10 (iA[9], iB[9], fio[8], oSUM[9], fio[9]);
full_addv x11 (iA[10], iB[10], fio[9], oSUM[10], fio[10]);
full_addv x12 (iA[11], iB[11], fio[10], oSUM[11], fio[11]);
full_addv x13 (iA[12], iB[12], fio[11], oSUM[12], fio[12]);
full_addv x14 (iA[13], iB[13], fio[12], oSUM[13], fio[13]);
full_addv x15 (iA[14], iB[14], fio[13], oSUM[14], fio[14]);
full_addv x16 (iA[15], iB[15], fio[14], oSUM[15], fio[15]);
full_addv x17 (iA[16], iB[16], fio[15], oSUM[16], fio[16]);
full_addv x18 (iA[17], iB[17], fio[16], oSUM[17], fio[17]);
full_addv x19 (iA[18], iB[18], fio[17], oSUM[18], fio[18]);
full_addv x20 (iA[19], iB[19], fio[18], oSUM[19], fio[19]);
full_addv x21 (iA[20], iB[20], fio[19], oSUM[20], fio[20]);
full_addv x22 (iA[21], iB[21], fio[20], oSUM[21], fio[21]);
full_addv x23 (iA[22], iB[22], fio[21], oSUM[22], fio[22]);
full_addv x24 (iA[23], iB[23], fio[22], oSUM[23], fio[23]);
full_addv x25 (iA[24], iB[24], fio[23], oSUM[24], fio[24]);
full_addv x26 (iA[25], iB[25], fio[24], oSUM[25], fio[25]);
full_addv x27 (iA[26], iB[26], fio[25], oSUM[26], fio[26]);
full_addv x28 (iA[27], iB[27], fio[26], oSUM[27], fio[27]);
full_addv x29 (iA[28], iB[28], fio[27], oSUM[28], fio[28]);
full_addv x30 (iA[29], iB[29], fio[28], oSUM[29], fio[29]);
full_addv x31 (iA[30], iB[30], fio[29], oSUM[30], fio[30]);
full_addv x32 (iA[31], iB[31], fio[30], oSUM[31], oCARRY);


endmodule
