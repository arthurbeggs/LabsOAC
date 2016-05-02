module add32cvs (sum, a, b, cIn, clk);

output reg [31:0] sum;

input [31:0] a;
input [31:0] b;
input cIn;
input clk;

always @(posedge clk)

{sum} = a + b + cIn;

endmodule