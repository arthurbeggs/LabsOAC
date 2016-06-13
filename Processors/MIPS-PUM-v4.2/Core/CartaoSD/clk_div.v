module CLK_Divider(
    input              CLKin,
    input              Reset,
    input       [7:0]  State,
    output reg         CLKout
);

reg         CLKfast, CLKslow;
reg         COUNTERfast;
reg  [4:0]  COUNTERslow;

initial
begin
    CLKfast     <= 1'b0;
    CLKslow     <= 1'b0;
    COUNTERfast <= 1'b0;
    COUNTERslow <= 5'b0;
end

always @(posedge CLKin)
begin
    CLKout  <= (State != 8'h00 && State < 8'h70) ? CLKslow : CLKfast;
end

always @(posedge CLKin)
begin
    if (COUNTERslow == 5'b11111)        //NOTE: 781KHz
        begin
            CLKslow     <= ~CLKslow;
            COUNTERslow <= 5'b0;
        end
    else    COUNTERslow <= COUNTERslow + 1'b1;

    if (COUNTERfast == 1'b1)            //NOTE: 25MHz
        begin
            CLKfast     <= ~CLKfast;
            COUNTERfast <= 1'b0;
        end
    else    COUNTERfast <= COUNTERfast + 1'b1;
end

// //NOTE: Bloco com reset
// always @(posedge CLKin)
// begin
//     if (Reset)
//     begin
//         CLKfast     <= 1'b0;
//         CLKslow     <= 1'b0;
//         COUNTERfast <= 1'b0;
//         COUNTERslow <= 5'b0;
//     end
//     else
//     begin
//         if (COUNTERslow == 5'b11111)        //NOTE: 781KHz
//             begin
//                 CLKslow     <= ~CLKslow;
//                 COUNTERslow <= 5'b0;
//             end
//         else    COUNTERslow <= COUNTERslow + 1'b1;
//
//         if (COUNTERfast == 1'b1)            //NOTE: 25MHz
//             begin
//                 CLKfast     <= ~CLKfast;
//                 COUNTERfast <= 1'b0;
//             end
//         else    COUNTERfast <= COUNTERfast + 1'b1;
//     end
// end

endmodule
