/*
full add
 */
 
module full_addv (iA, iB, cin, oSUM, oCARRY);


/* I/O type definition */
input iA, iB, cin;
output oSUM, oCARRY;
wire L1, L2, L3;

//half_addv (input1, input2, oSUM, oCARRY);
half_addv U1 (iA, iB, L1, L2);
half_addv U2 (L1, cin, oSUM, L3);
or        U3 (oCARRY, L3, L2);

endmodule
