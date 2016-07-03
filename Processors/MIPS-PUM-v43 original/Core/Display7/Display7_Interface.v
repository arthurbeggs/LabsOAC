module Display7_Interface (
	output [6:0] HEX0_D, HEX1_D, HEX2_D, HEX3_D, HEX4_D, HEX5_D, HEX6_D, HEX7_D,  // Displays Hex
	output HEX0_DP, HEX1_DP, HEX2_DP, HEX3_DP, HEX4_DP, HEX5_DP, HEX6_DP, HEX7_DP, // Displays Dot Point
	input [31:0] Output
	);
	
assign HEX0_DP=1'b1;
assign HEX1_DP=1'b1;
assign HEX2_DP=1'b1;
assign HEX3_DP=1'b1;
assign HEX4_DP=1'b1;
assign HEX5_DP=1'b1;
assign HEX6_DP=1'b1;
assign HEX7_DP=1'b1;

Decoder7 Dec0 (
	.In(Output[3:0]),
	.Out(HEX0_D)
	);

Decoder7 Dec1 (
	.In(Output[7:4]),
	.Out(HEX1_D)
	);

Decoder7 Dec2 (
	.In(Output[11:8]),
	.Out(HEX2_D)
	);

Decoder7 Dec3 (
	.In(Output[15:12]),
	.Out(HEX3_D)
	);

Decoder7 Dec4 (
	.In(Output[19:16]),
	.Out(HEX4_D)
	);

Decoder7 Dec5 (
	.In(Output[23:20]),
	.Out(HEX5_D)
	);

Decoder7 Dec6 (
	.In(Output[27:24]),
	.Out(HEX6_D)
	);

Decoder7 Dec7 (
	.In(Output[31:28]),
	.Out(HEX7_D)
	);
	
endmodule