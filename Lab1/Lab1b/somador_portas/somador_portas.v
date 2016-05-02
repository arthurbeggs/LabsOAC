/*
full add
 */
 
module half_addv (iA, iB, oSUM, oCARRY);


/* I/O type definition */
input iA, iB;
output oSUM, oCARRY;


assign	oSUM = iA ^ iB;
assign	oCARRY = iA && iB;

endmodule
