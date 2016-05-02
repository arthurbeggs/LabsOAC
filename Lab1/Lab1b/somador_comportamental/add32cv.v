module add32cv (sum, a, b, cIn);

output reg [31:0] sum;

input [31:0] a;
input [31:0] b;
input cIn;

always @(a, b, cIn)

{sum} = a + b + cIn;

endmodule
