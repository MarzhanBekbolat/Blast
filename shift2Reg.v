`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2018 14:18:29
// Design Name: 
// Module Name: shift2Reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift2Reg(
input clk,
input rst,
input load,
input shift,
input [511:0] inData,
output [511:0] outData
);

reg [533:0] shiftReg;

assign outData = shiftReg[533:22];

always @(posedge clk)
begin
    if(load & shift)
    begin
        shiftReg[513:0] <= {inData,2'b00};
        shiftReg[533:514] <= {shiftReg[531:512]};
    end
    else if(load)
        shiftReg[511:0] <= inData;
    else if(shift)
        shiftReg <= {shiftReg[531:0],2'b00};
end
endmodule
