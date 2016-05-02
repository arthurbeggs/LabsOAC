module add4cvs (sum, a, b, cIn, clk);

output reg [3:0] sum;

input [3:0] a;
input [3:0] b;
input cIn;
input clk;

always @(posedge clk)

{sum} = a + b + cIn;

endmodule