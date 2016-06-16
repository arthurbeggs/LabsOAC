/*
 * Bloco de Controle UNICICLO
 *
 */

 module Control_UNI(
    input  wire        iCLK, iBranchC1,
    input  wire [5:0]  iOp, iFunct,
    input  wire [4:0]  iFmt, iRt,            // 1/2016. Adicionado iRt.
    output wire        oEscreveReg, oLeMem, oEscreveMem, oEscreveRegFPU, oFPFlagWrite,
    output wire [1:0]  oRegDst, oOpALU, oOrigALU, oDataRegFPU, oRegDstFPU, oFPUparaMem,
    output wire [2:0]  oOrigPC, oMemparaReg,
    // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
    input         iExcLevel,
    input         iALUOverflow,
    input         iFPALUOverflow,
    input         iFPALUUnderflow,
    input         iFPALUNaN,
    input         iUserMode,
    input  [7:0]  iPendingInterrupt,
    output        oEscreveRegCOP0,
    output        oEretCOP0,
    output        oExcOccurredCOP0,
    output        oBranchDelayCOP0,
    output [4:0]  oExcCodeCOP0
);

wire        wInterruptNotZero, wNotExcLevel, wNotUserMode, wIntException, wALUException, wFPALUException;
wire [4:0]  wALUExcCode, wFPALUExcCode;

assign wInterruptNotZero    = iPendingInterrupt != 8'b0;
assign wNotExcLevel         = ~iExcLevel;
assign wNotUserMode         = ~iUserMode;
assign wIntException        = wInterruptNotZero && wNotExcLevel;
assign wALUException        = (iALUOverflow || wInterruptNotZero) && wNotExcLevel;
assign wALUExcCode          = iALUOverflow ? EXCODEALU : EXCODEINT;
assign wFPALUException      = (iFPALUOverflow || iFPALUUnderflow || wInterruptNotZero) && wNotExcLevel;
assign wFPALUExcCode        = iFPALUOverflow || iFPALUUnderflow ? EXCODEFPALU : EXCODEINT;

initial
begin
    oRegDst             = 2'b00;
    oOrigALU            = 2'b00;
    oMemparaReg         = 3'b000;
    oEscreveReg         = 1'b0;
    oLeMem              = 1'b0;
    oEscreveMem         = 1'b0;
    oOrigPC             = 3'b000;
    oOpALU              = 2'b00;
    oEscreveRegFPU      = 1'b0;
    oRegDstFPU          = 2'b00;
    oFPUparaMem         = 2'b00;
    oDataRegFPU         = 2'b00;
    oFPFlagWrite        = 1'b0;
    oEscreveRegCOP0     = 1'b0;
    oEretCOP0           = 1'b0;
    oExcOccurredCOP0    = 1'b0;
    oBranchDelayCOP0    = 1'b0;
    oExcCodeCOP0        = 5'b0;
end

//always @(iOp, iFmt, iBranchC1, iFunct, iExcLevel, iALUOverflow, iFPALUOverflow,
//        iFPALUUnderflow, iFPALUNaN, iUserMode, iPendingInterrupt, wIntException, wNotExcLevel,
//        wALUException, wALUExcCode)
always @(*)
begin
    case(iOp)

        OPCSW,
        OPCSH,
        OPCSB:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b1;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b10;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCLBU,
        OPCLHU,
        OPCLB,
        OPCLH,
        OPCLW:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b110;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b1;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCBEQ:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b00;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b001;
            oOpALU              = 2'b01;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCBNE:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b00;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b101;
            oOpALU              = 2'b01;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCRFMT:
        begin
            case (iFunct)
                FUNJR:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b011;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b1;
                    oExcCodeCOP0        = EXCODEINT;
                end
                FUNSYS:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b100;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wNotExcLevel;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODESYS;
                end

                FUNADD,
                FUNSUB:
                begin
                    oRegDst             = 2'b01;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b10;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wALUException;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = wALUExcCode;
                end

                FUNSLL,
                FUNSRL,
                FUNSRA,
                FUNMFHI,
                FUNMTHI,
                FUNMFLO,
                FUNMTLO,
                FUNMULT,
                FUNDIV,
                FUNMULTU,
                FUNDIVU,
                FUNADDU,
                FUNSUBU,
                FUNAND,
                FUNOR,
                FUNXOR,
                FUNNOR,
                FUNSLT,
                FUNSLTU,
                FUNSLLV,
                FUNSRLV,
                FUNSRAV:
                begin
                    oRegDst             = 2'b01;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b10;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINT;
                end

                // instrucao invalida
                default:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wNotExcLevel;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end
            endcase
        end

        OPCJMP:
        begin
            oRegDst             = 2'b01;
            oOrigALU            = 2'b00;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b010;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCJAL:                                     // Alterado em 1/2016 para implementar bgezal e bltzal.
        begin
            oRegDst             = 2'b10;
            oOrigALU            = 2'b11;            // Alterado 1/2016 2'b00 => 2'b11.
            oMemparaReg         = 3'b010;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b010;
            oOpALU              = 2'b11;            // Alterado 1/2016 2'b00 => 2'b11.
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCADDI:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b11;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wALUException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = wALUExcCode;
        end

        OPCADDIU,
        OPCSLTI,
        OPCSLTIU:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b11;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCANDI,
        OPCXORI,
        OPCORI:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b10;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b11;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCLUI:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b00;
            oMemparaReg         = 3'b011;
            oEscreveReg         = 1'b1;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        /*OPERACOES DA FPU ABAIXO*/

        OPCFLT:
        begin
            case(iFmt)
                FMTMTC:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b1;
                    oDataRegFPU         = 2'b10;
                    oRegDstFPU          = 2'b01;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINT;
                end

                FMTMFC:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b100;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINT;
                end

                FMTBC1:
                begin
                    case (iBranchC1)
                        1'b0:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b111;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b0;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wIntException;
                            oBranchDelayCOP0    = 1'b1;
                            oExcCodeCOP0        = EXCODEINT;
                        end

                        1'b1:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b110;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b0;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wIntException;
                            oBranchDelayCOP0    = 1'b1;
                            oExcCodeCOP0        = EXCODEINT;
                        end
                    endcase
                end

                FMTW:
                begin
                    case (iFunct)
                        FUNCVTSW:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b1;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wFPALUException;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = wFPALUExcCode;
                        end

                        // instrucao invalida
                        default:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b0;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wNotExcLevel;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = EXCODEINSTR;
                        end
                    endcase
                end

                FMTS:
                begin
                    case (iFunct)
                        FUNADDS,
                        FUNSUBS,
                        FUNMULS,
                        FUNDIVS:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b1;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wFPALUException;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = wFPALUExcCode;
                        end

                        FUNSQRT,
                        FUNABS,
                        FUNNEG:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b1;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wIntException;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = EXCODEINT;
                        end

                        FUNCVTWS:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b1;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = (iFPALUOverflow || wInterruptNotZero) && wNotExcLevel;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = iFPALUOverflow ? EXCODEFPALU : EXCODEINT;
                        end

                        FUNCEQ,
                        FUNCLT,
                        FUNCLE:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b0;
                            oDataRegFPU         = 2'b00;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b1;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wIntException;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = EXCODEINT;
                        end

                        FUNMOV:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b1;
                            oDataRegFPU         = 2'b11;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wIntException;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = EXCODEINT;
                        end

                        // instrucao invalida
                        default:
                        begin
                            oRegDst             = 2'b00;
                            oOrigALU            = 2'b00;
                            oMemparaReg         = 3'b000;
                            oEscreveReg         = 1'b0;
                            oLeMem              = 1'b0;
                            oEscreveMem         = 1'b0;
                            oOrigPC             = 3'b000;
                            oOpALU              = 2'b00;
                            oEscreveRegFPU      = 1'b0;
                            oRegDstFPU          = 2'b00;
                            oFPUparaMem         = 2'b00;
                            oDataRegFPU         = 2'b00;
                            oFPFlagWrite        = 1'b0;
                            oEscreveRegCOP0     = 1'b0;
                            oEretCOP0           = 1'b0;
                            oExcOccurredCOP0    = wNotExcLevel;
                            oBranchDelayCOP0    = 1'b0;
                            oExcCodeCOP0        = EXCODEINSTR;
                        end
                    endcase
                end

                // instrucao invalida
                default:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wNotExcLevel;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end
            endcase
        end

        OPCSWC1:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b1;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oDataRegFPU         = 2'b00;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b01;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCLWC1:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b01;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b1;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b1;
            oDataRegFPU         = 2'b01;
            oRegDstFPU          = 2'b10;
            oFPUparaMem         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINT;
        end

        // 1/2016, Implementar intruções bgez, bgezal, bltz, bltzal.
        OPCBGE_LTZ:
        begin
            case (iRt)
                RTBGEZ:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b11;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b001;
                    oOpALU              = 2'b11;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b1;
                    oExcCodeCOP0        = EXCODEINT;
                end

                RTBGEZAL:
                begin
                    oRegDst             = 2'b10;
                    oOrigALU            = 2'b11;
                    oMemparaReg         = 3'b010;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b001;
                    oOpALU              = 2'b11;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b1;
                    oExcCodeCOP0        = EXCODEINT;
                end

                RTBLTZ:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b11;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b101;
                    oOpALU              = 2'b11;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b1;
                    oExcCodeCOP0        = EXCODEINT;
                end


                RTBLTZAL:
                begin
                    oRegDst             = 2'b11;
                    oOrigALU            = 2'b11;
                    oMemparaReg         = 3'b010;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b101;
                    oOpALU              = 2'b11;
                    oEscreveRegFPU      = 1'b0;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oDataRegFPU         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wIntException;
                    oBranchDelayCOP0    = 1'b1;
                    oExcCodeCOP0        = EXCODEINT;
                end

                // instrucao invalida
                default:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wNotExcLevel;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end
            endcase
        end

        // 1/2016
        OPCBLEZ:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b11;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b001;
            oOpALU              = 2'b11;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        OPCBGTZ:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b11;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b101;
            oOpALU              = 2'b11;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wIntException;
            oBranchDelayCOP0    = 1'b1;
            oExcCodeCOP0        = EXCODEINT;
        end

        // feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
        OPCCOP0:
        begin
            case(iFmt)
                FMTMFC:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b101;
                    oEscreveReg         = 1'b1;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = iUserMode;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end

                FMTMTC:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = wNotUserMode;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = iUserMode;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end

                FMTERET:
                begin
                    if (iFunct == FUNERET)
                    begin
                        oRegDst             = 2'b00;
                        oOrigALU            = 2'b00;
                        oMemparaReg         = 3'b000;
                        oEscreveReg         = 1'b0;
                        oLeMem              = 1'b0;
                        oEscreveMem         = 1'b0;
                        oOrigPC             = 3'b100;
                        oOpALU              = 2'b00;
                        oEscreveRegFPU      = 1'b0;
                        oDataRegFPU         = 2'b00;
                        oRegDstFPU          = 2'b00;
                        oFPUparaMem         = 2'b00;
                        oFPFlagWrite        = 1'b0;
                        oEscreveRegCOP0     = 1'b0;
                        oEretCOP0           = wNotUserMode;
                        oExcOccurredCOP0    = iUserMode;
                        oBranchDelayCOP0    = 1'b0;
                        oExcCodeCOP0        = EXCODEINSTR;
                    end
                    // instrucao invalida
                    else
                    begin
                        oRegDst             = 2'b00;
                        oOrigALU            = 2'b00;
                        oMemparaReg         = 3'b000;
                        oEscreveReg         = 1'b0;
                        oLeMem              = 1'b0;
                        oEscreveMem         = 1'b0;
                        oOrigPC             = 3'b000;
                        oOpALU              = 2'b00;
                        oEscreveRegFPU      = 1'b0;
                        oDataRegFPU         = 2'b00;
                        oRegDstFPU          = 2'b00;
                        oFPUparaMem         = 2'b00;
                        oFPFlagWrite        = 1'b0;
                        oEscreveRegCOP0     = 1'b0;
                        oEretCOP0           = 1'b0;
                        oExcOccurredCOP0    = wNotExcLevel;
                        oBranchDelayCOP0    = 1'b0;
                        oExcCodeCOP0        = EXCODEINSTR;
                    end
                end

                // instrucao invalida
                default:
                begin
                    oRegDst             = 2'b00;
                    oOrigALU            = 2'b00;
                    oMemparaReg         = 3'b000;
                    oEscreveReg         = 1'b0;
                    oLeMem              = 1'b0;
                    oEscreveMem         = 1'b0;
                    oOrigPC             = 3'b000;
                    oOpALU              = 2'b00;
                    oEscreveRegFPU      = 1'b0;
                    oDataRegFPU         = 2'b00;
                    oRegDstFPU          = 2'b00;
                    oFPUparaMem         = 2'b00;
                    oFPFlagWrite        = 1'b0;
                    oEscreveRegCOP0     = 1'b0;
                    oEretCOP0           = 1'b0;
                    oExcOccurredCOP0    = wNotExcLevel;
                    oBranchDelayCOP0    = 1'b0;
                    oExcCodeCOP0        = EXCODEINSTR;
                end
            endcase
        end

        // instrucao invalida
        default:
        begin
            oRegDst             = 2'b00;
            oOrigALU            = 2'b00;
            oMemparaReg         = 3'b000;
            oEscreveReg         = 1'b0;
            oLeMem              = 1'b0;
            oEscreveMem         = 1'b0;
            oOrigPC             = 3'b000;
            oOpALU              = 2'b00;
            oEscreveRegFPU      = 1'b0;
            oRegDstFPU          = 2'b00;
            oFPUparaMem         = 2'b00;
            oDataRegFPU         = 2'b00;
            oFPFlagWrite        = 1'b0;
            oEscreveRegCOP0     = 1'b0;
            oEretCOP0           = 1'b0;
            oExcOccurredCOP0    = wNotExcLevel;
            oBranchDelayCOP0    = 1'b0;
            oExcCodeCOP0        = EXCODEINSTR;
        end
    endcase
end

endmodule
