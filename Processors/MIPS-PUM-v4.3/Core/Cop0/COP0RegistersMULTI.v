
module COP0RegistersMULTI(
    iCLK,
    iCLR,

    // register file interface
    iReadRegister,
    iWriteRegister,
    iWriteData,
    iRegWrite,
    oReadData,

    // eret interface
    iEret,

    // COP0 interface
    iExcOccurred,
    iBranchDelay,
    iPendingInterrupt,
    iInterrupted,
    iExcCode,
    oInterruptMask,
    oUserMode,
    oExcLevel,
    oInterruptEnable,
    // DE2-70 interface
    iRegDispSelect,
    oRegDisp
);

// register file indexes
parameter   REG_COUNT   = 3'b000,
            REG_COMPARE = 3'b001,
            REG_SR      = 3'b010,
            REG_CAUSE   = 3'b011,
            REG_EPC     = 3'b100,
// registers bits
            CAUSE_BD    = 5'd31,
            SR_UM       = 5'd4,
            SR_EL       = 5'd1,
            SR_IE       = 5'd0;

input iCLK;
input iCLR;

// register file declarations
input  [4:0]  iReadRegister;
input  [4:0]  iWriteRegister;
input  [31:0] iWriteData;
input         iRegWrite;
output [31:0] oReadData;

// eret declarations
input         iEret;

// COP0 declarations
input         iExcOccurred;
input         iBranchDelay;
input  [7:0]  iPendingInterrupt;
input         iInterrupted;
input  [4:0]  iExcCode;
output [7:0]  oInterruptMask;
output        oUserMode;
output        oExcLevel;
output        oInterruptEnable;

// DE2-70 declarations
input  [4:0]  iRegDispSelect;
output [31:0] oRegDisp;

// register file
reg [31:0] registers[4:0];

// register file local wires
wire [2:0]  wReadRegister;
wire [2:0]  wWriteRegister;
wire [2:0]  wRegDispSelect;

// count register clock
reg count_clock;

// COP0 local wires
wire [7:0]  wInterruptMask;
wire        wCountLimit;

// register file assignments
wire [4:0]  w1,w2;
assign w1               = iReadRegister  == 5'd9 ? REG_COUNT : iReadRegister  - 5'd10;
assign wReadRegister    = w1[2:0];
assign w2               = iWriteRegister == 5'd9 ? REG_COUNT : iWriteRegister - 5'd10;
assign wWriteRegister   = w2[2:0];
assign oReadData        = iEret ? (registers[REG_CAUSE][CAUSE_BD] ? registers[REG_EPC] : (registers[REG_EPC] + 32'd4)) : registers[wReadRegister];

// COUNT and COMPARE interruption
reg count_limit_ff, count_interrupted_ff;
wire wCountInterrupt;
always @(posedge wCountLimit)
    count_limit_ff          <= ~count_limit_ff;

always @(negedge iInterrupted)
    count_interrupted_ff    <= count_limit_ff;

assign wCountInterrupt = count_limit_ff ^ count_interrupted_ff;

// COP0 assignments
assign wCountLimit      = registers[REG_COUNT] == registers[REG_COMPARE] && count_clock;
assign wInterruptMask   = registers[REG_SR][SR_IE] ? (registers[REG_SR][15:8] & {iPendingInterrupt[7:3], wCountInterrupt, iPendingInterrupt[1:0]}) : 8'b0;
assign oInterruptMask   = wInterruptMask;
assign oUserMode        = registers[REG_SR][SR_UM];
assign oExcLevel        = registers[REG_SR][SR_EL];
assign oInterruptEnable = registers[REG_SR][SR_IE];

// DE2-70 assignments
wire [4:0]  w3;
assign w3               = iRegDispSelect == 5'd9 ? REG_COUNT : iRegDispSelect - 5'd10;
assign wRegDispSelect   = w3[2:0];
assign oRegDisp         = registers[wRegDispSelect];

// initialization
initial
begin
    // register file initialization
    registers[REG_COUNT]    <= 32'b0;
    registers[REG_COMPARE]  <= 32'b0;
    registers[REG_SR]       <= 32'h00000911; // apenas a interrupcao de teclado eh habilitada incialmente
    registers[REG_CAUSE]    <= 32'b0;
    registers[REG_EPC]      <= 32'b0;

    // count register clock initialization
    count_clock <= 1'b0;
end

// clock writes
always @(posedge iCLK)
begin
    // clear set
    if (iCLR)
    begin
        // clearing register file
        registers[REG_COUNT]    <= 32'b0;
        registers[REG_COMPARE]  <= 32'b0;
        registers[REG_SR]       <= 32'h00000911; // apenas a interrupcao de teclado eh habilitada incialmente
        registers[REG_CAUSE]    <= 32'b0;
        registers[REG_EPC]      <= 32'b0;

        // clearing count register
        count_clock     <= 1'b0;
    end
    // clear not set
    else
    begin
        // eret instruction
        if (iEret)
        begin
            registers[REG_SR][SR_UM]    <= 1'b1;
            registers[REG_SR][SR_EL]    <= 1'b0;

            // increment count register
            if (wCountLimit)
                registers[REG_COUNT]    <= 32'b0;
            else if (count_clock)
                registers[REG_COUNT]    <= registers[REG_COUNT] + 32'd1;
        end
        // exception occurred
        else if (iExcOccurred)
        begin
            registers[REG_SR][SR_UM]        <= 1'b0;
            registers[REG_SR][SR_EL]        <= 1'b1;

            registers[REG_CAUSE][CAUSE_BD]  <= iBranchDelay;
            registers[REG_CAUSE][15:8]      <= wInterruptMask;
            registers[REG_CAUSE][6:2]       <= iExcCode;

            registers[REG_EPC]              <= iWriteData - 32'd4;

            // increment count register
            if (wCountLimit)
                registers[REG_COUNT]        <= 32'b0;
            else if (count_clock)
                registers[REG_COUNT]        <= registers[REG_COUNT] + 32'd1;
        end
        // writing register
        else if (iRegWrite)
        begin
            // writing to count register
            if (wWriteRegister == REG_COUNT)
                registers[REG_COUNT]        <= iWriteData;
            else
            // writing to another register
            begin
                registers[wWriteRegister]   <= iWriteData;

                // increment count register
                if (wCountLimit)
                    registers[REG_COUNT]    <= 32'b0;
                else if (count_clock)
                    registers[REG_COUNT]    <= registers[REG_COUNT] + 32'd1;
            end
        end
        // just increment the counter
        else if (wCountLimit)
            registers[REG_COUNT]    <= 32'b0;
        else if (count_clock)
            registers[REG_COUNT]    <= registers[REG_COUNT] + 32'd1;

        // inverting count register clock
        count_clock         <= ~count_clock;
    end
end

endmodule
