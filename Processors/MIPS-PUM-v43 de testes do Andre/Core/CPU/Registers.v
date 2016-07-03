/*
 * Registers.v
 *
 * Main processor register bank testbench.
 * Stores information in 32-bit registers. 31 registers are available for
 * writing and 32 are available for reading.
 * Also allows for two simultaneous data reads, has a write enable signal
 * input, is clocked and has an asynchronous reset signal input.
 */
module Registers (
	input wire iCLK, iCLR, iRegWrite,
	input wire [4:0] iReadRegister1, iReadRegister2, iWriteRegister, iRegDispSelect,
	input wire [31:0] iWriteData,
	output wire [31:0] oReadData1, oReadData2, oRegDisp, oRegA0, oRegV0,
	input wire [4:0] iVGASelect,
	output reg [31:0] oVGARead
	);

/* Local register bank */
reg [31:0] registers[31:0];

parameter	SPR=5'd29;					// $SP

integer i;

initial
begin
	for (i = 0; i <= 31; i = i + 1)
		registers[i] = 32'b0;
	registers[SPR] = STACK_ADDRESS;
end

/* Output definition */
assign oReadData1 =	registers[iReadRegister1];
assign oReadData2 =	registers[iReadRegister2];

assign oRegDisp =	registers[iRegDispSelect];
assign oRegV0	 =	registers[5'd2];
assign oRegA0	 =	registers[5'd4];
assign oVGARead = registers[iVGASelect];

/* Main block for writing and reseting */
`ifdef PIPELINE
	always @(negedge iCLK)
`else
	always @(posedge iCLK)
`endif
begin
	if (iCLR)
	begin
		for (i = 0; i <= 31; i = i + 1)
			registers[i] = 32'b0;
		registers[SPR] = STACK_ADDRESS;  // $SP
	end
	else
	if(iRegWrite)
		if (iWriteRegister != 5'b0)
			registers[iWriteRegister] = iWriteData;
end

endmodule

