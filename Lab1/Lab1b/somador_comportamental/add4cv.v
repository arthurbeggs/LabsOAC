module add4cv (sum, a, b, cIn);

output reg [3:0] sum;

input [3:0] a;
input [3:0] b;
input cIn;

always @(a, b, cIn)

{sum} = a + b + cIn;

endmodule