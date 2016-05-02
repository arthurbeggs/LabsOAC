module show_carry (
	input carry,
	output reg [6:0] display);
	
	always @(*)
		case (carry)
			1'b1 : display = ~7'b0000110;
			1'b0 : display = ~7'b0111111;
			default : display = ~7'b0000000;
		endcase
	
endmodule
