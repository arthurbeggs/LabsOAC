/*
 * ALUcontrol.v
 *
 * Arithmetic Logic Unit control module.
 * Generates control signal to the ALU depending on the opcode and the funct field in the
 * current operation and on the signal sent by the processor control module.
 *
 * ALUOp    |    Control signal
 * -------------------------------------------
 * 00        |    The ALU performs an add operation.
 * 01        |    The ALU performs a subtract operation.
 * 10        |    The funct field determines the ALU operation.
 * 11        |    The opcode field determines the ALU operation.
 */

module ALUControl (iFunct, iOpcode, iRt, iALUOp, oControlSignal);


/* I/O type definition */
input wire [5:0] iFunct, iOpcode, iRt;                      // 1/2016. Adicionado iRt.
input wire [1:0] iALUOp;
output reg [4:0] oControlSignal;

always @(iFunct, iOpcode, iALUOp)
begin
    case (iALUOp)
        2'b00:
            oControlSignal  = OPADD;
        2'b01:
            oControlSignal  = OPSUB;
        2'b10:
        begin
            case (iFunct)
                FUNSLL:
                    oControlSignal  = OPSLL;
                FUNSRL:
                    oControlSignal  = OPSRL;
                FUNSRA:
                    oControlSignal  = OPSRA;
                FUNMFHI:
                    oControlSignal  = OPMFHI;                // 2015/1
                FUNMTHI:
                    oControlSignal  = OPMTHI;
                FUNMFLO:
                    oControlSignal  = OPMFLO;                // 2015/1
                FUNMTLO:
                    oControlSignal  = OPMTLO;
                FUNMULT:
                    oControlSignal  = OPMULT;
                FUNDIV:
                    oControlSignal  = OPDIV;
                FUNMULTU:
                    oControlSignal  = OPMULTU;
                FUNDIVU:
                    oControlSignal  = OPDIVU;
                FUNADD:
                    oControlSignal  = OPADD;
                FUNADDU:
                    oControlSignal  = OPADD;
                FUNSUB:
                    oControlSignal  = OPSUB;
                FUNSUBU:
                    oControlSignal  = OPSUB;
                FUNAND:
                    oControlSignal  = OPAND;
                FUNOR:
                    oControlSignal  = OPOR;
                FUNXOR:
                    oControlSignal  = OPXOR;
                FUNNOR:
                    oControlSignal  = OPNOR;
                FUNSLT:
                    oControlSignal  = OPSLT;
                FUNSLTU:
                    oControlSignal  = OPSLTU;
                FUNSRLV:
                    oControlSignal  = OPSRLV;
                FUNSLLV:
                    oControlSignal  = OPSLLV;
                FUNSRAV:
                    oControlSignal  = OPSRAV;
                default:
                    oControlSignal  = 5'b00000;
            endcase
        end
        2'b11:
            case (iOpcode)
                OPCADDI:
                    oControlSignal  = OPADD;
                OPCADDIU:
                    oControlSignal  = OPADD;
                OPCSLTI:
                    oControlSignal  = OPSLT;
                OPCSLTIU:
                    oControlSignal  = OPSLTU;
                OPCANDI:
                    oControlSignal  = OPAND;
                OPCORI:
                    oControlSignal  = OPOR;
                OPCXORI:
                    oControlSignal  = OPXOR;
                OPCLUI:
                    oControlSignal  = OPLUI;
                OPCJAL:                                     //2016/1
                    oControlSignal  = OPAND;
                OPCBLEZ,                                    //2016/1
                OPCBGTZ:
                    oControlSignal <= OPSGT;
                OPCBGE_LTZ:
                begin
                    case (iRt)
                        RTBGEZ,
                        RTBGEZAL,
                        RTBLTZ,
                        RTBLTZAL:
                            oControlSignal  = OPSLT;
                        default:
                            oControlSignal  = 5'b00000;
                    endcase
                end
                default:
                    oControlSignal  = 5'b00000;
            endcase
    endcase
end

endmodule
