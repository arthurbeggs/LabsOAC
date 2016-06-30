/*Pipeline Branch Module*/

/*The following was implemented to solve the processing of branch operations in the pipeline processor.
It makes possible for the main control module to have only one branch control signal, instead of eight.
Also, it performs all the branch comparations and decides if the branch is taken or not.
In short, all the branch processing is made inside of this module.*/

//INPUTS
/*
iBControlSignal : wire from the \CPU\Control_PIPEM - defines if this module is active or inactive
iOpcode,
iA,
iB,
iRt
*/
//OUTPUTS

//Implemented in 1/21'b016
/*******************************************************************************************************/

module Branch_PIPEM (
iBControlSignal,
iOpcode,
iA,
iB,
iRt,
oBranch,
oLink
);

input wire iBControlSignal;
input wire [5:0] iOpcode;
input wire [31:0] iA, iB;
input wire [4:0] iRt;
output wire oBranch, oLink;

always @ (*) begin 
if (iBControlSignal == 1)
	begin
		case (iOpcode)
			OPCBEQ:
				begin
					oBranch = iA == iB;
					oLink = 1'b0;
				end
			OPCBNE:
				begin
					oBranch = iA != iB;
					oLink = 1'b0;
				end
			OPCBGTZ:
				begin
					case (iRt)
						RTZERO:
							begin
								oBranch = iA > ZERO;
								oLink = 1'b0;
							end
						default: 
							begin
								oBranch = 1'b0;
								oLink = 1'b0;
							end
						endcase
				end
			OPCBLEZ:
				begin
					case (iRt)
						RTZERO:
							begin
								oBranch = iA <= ZERO;
								oLink = 1'b0;
							end
						default: 
							begin
								oBranch = 1'b0;
								oLink = 1'b0;
							end
					endcase
				end
			OPCBGE_LTZ:
				begin
					case (iRt)
						RTBGEZ:
							begin
								oBranch = iA >= ZERO;
								oLink = 1'b0;
							end
						RTBGEZAL:
							begin
								oBranch = iA >= ZERO;
								oLink = 1'b1;
							end
						RTBLTZ:
							begin
								oBranch = iA < iB;
								oLink = 1'b0;
							end
						RTBLTZAL:
							begin
								oBranch = iA < iB;
								oLink = 1'b1;
							end
					default: 
						begin
							oBranch = 1'b0;
							oLink = 1'b0;
						end
					endcase
				end
		endcase
	end
else
	begin
		case (iOpcode)
			OPCJAL:
				begin
					oBranch = 1'b0;
					oLink = 1'b0;
				end
			default:
				begin
					oBranch = 1'b0;
					oLink = 1'b0;
				end
		endcase
	end
end
endmodule
