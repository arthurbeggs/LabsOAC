module TecladoPS2_Interface(
    input iCLK,
    input iCLK_50,
    input Reset,
    inout PS2_KBCLK,
    inout PS2_KBDAT,

    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData,

    // Para o Coprocessador 0 - Interrupcao
    output reg ps2_scan_ready_clock,
    output reg keyboard_interrupt
    );


wire [7:0]  PS2scan_code;
reg  [7:0]  PS2history[7:0]; // buffer de 8 bytes
wire        PS2read, PS2scan_ready;

oneshot pulser(
   .pulse_out(PS2read),
   .trigger_in(PS2scan_ready),
   .clk(iCLK_50)
);

keyboard kbd(
  .keyboard_clk(PS2_KBCLK),
  .keyboard_data(PS2_KBDAT),
  .clock50(iCLK_50),
  .reset(Reset),
  .read(PS2read),
  .scan_ready(PS2scan_ready),
  .scan_code(PS2scan_code)
);

//reg ps2_scan_ready_clock;
//reg keyboard_interrupt;
always @(posedge PS2scan_ready)
    ps2_scan_ready_clock    <= ~ps2_scan_ready_clock;

always @(posedge iCLK)
    keyboard_interrupt      <= ps2_scan_ready_clock;


always @(posedge PS2scan_ready, posedge Reset)
begin
    if(Reset)
        begin
        PS2history[7] <= 8'b0;
        PS2history[6] <= 8'b0;
        PS2history[5] <= 8'b0;
        PS2history[4] <= 8'b0;
        PS2history[3] <= 8'b0;
        PS2history[2] <= 8'b0;
        PS2history[1] <= 8'b0;
        PS2history[0] <= 8'b0;
        end
    else
        begin
        PS2history[7] <= PS2history[6];
        PS2history[6] <= PS2history[5];
        PS2history[5] <= PS2history[4];
        PS2history[4] <= PS2history[3];
        PS2history[3] <= PS2history[2];
        PS2history[2] <= PS2history[1];
        PS2history[1] <= PS2history[0];
        PS2history[0] <= PS2scan_code;
        end
end




always @(*)
        if(wReadEnable)
            begin
                if(wAddress==BUFFER0_TECLADO_ADDRESS)  wReadData = {PS2history[3],PS2history[2],PS2history[1],PS2history[0]}; else
                if(wAddress==BUFFER1_TECLADO_ADDRESS)  wReadData = {PS2history[7],PS2history[6],PS2history[5],PS2history[4]}; else
                wReadData   = 32'hzzzzzzzz;
            end
         else wReadData     = 32'hzzzzzzzz;


endmodule
