module show_carry_s (
	input carry,
	output reg [6:0] display,
	input clock);
	
	//always @(*)
	always@(posedge clock)
		case (carry)
			1'b1 : display = ~7'b0000110;
			1'b0 : display = ~7'b0111111;
			default : display = ~7'b0000000;
		endcase
	
endmodule
