
module DataMemory_Interface (
    input         iCLK, iCLKMem,
    //  Barramento de IO
    input         wReadEnable, wWriteEnable,
    input  [3:0]  wByteEnable,
    input  [31:0] wAddress, wWriteData,
    output [31:0] wReadData
    // input  [31:0] wAddressS,
    // output [31:0] wReadDataS
);



UserDataBlock MB0 (
    .address(wAddress[12:2]), // Memoria em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWriteMB0),  //wMemWriteMB0
    .q(wMemDataMB0)
);


/*
UserDataBlockDouble MB0 (
    .address_a(wAddress[12:2]), // Memoria em words
    .byteena_a(wByteEnable),
    .clock(iCLKMem),
    .data_a(wWriteData),
    .wren_a(wMemWriteMB0),  //wMemWriteMB0
    .q_a(wMemDataMB0),

    .address_b(wAddressS[12:2]),
    .data_b(32'b0),
    .wren_b(1'b0),
    .q_b(wReadDataS)
);
*/

SysDataBlock MB1 (
    .address(wAddress[10:2]), // Memoria em words - reduzido
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWriteMB1),
    .q(wMemDataMB1)
);


    //reg MemWritten;
    //initial MemWritten <= 1'b0;
    //always @(iCLKMem) MemWritten <= iCLKMem;


    wire        wMemWriteMB0, wMemWriteMB1;
    wire [31:0] wMemDataMB0, wMemDataMB1;
    wire        is_sysmem, is_usermem;

    assign is_usermem = wAddress >= BEGINNING_DATA  &&  wAddress <= END_DATA;       // Memoria usuario  .data
    assign is_sysmem  = wAddress >= BEGINNING_KDATA &&  wAddress <= END_KDATA;      // Memoria do sistema .kdata

//    assign wMemWriteMB0 = ~MemWritten && wWriteEnable && is_usermem;              // Controle de escrita no MB0
//    assign wMemWriteMB1 = ~MemWritten && wWriteEnable && is_sysmem;               // Controle de escrita no MB1

    assign wMemWriteMB0 = wWriteEnable && is_usermem;                               // Controle de escrita no MB0
    assign wMemWriteMB1 = wWriteEnable && is_sysmem;                                // Controle de escrita no MB1

    always @(*)
        if(wReadEnable)
            begin
                if(is_sysmem)   wReadData = wMemDataMB1; else
                if(is_usermem)  wReadData = wMemDataMB0; else
                wReadData = 32'hzzzzzzzz;
            end
        else
            wReadData = 32'hzzzzzzzz;

endmodule
