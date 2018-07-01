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
input dataValid,
output [511:0] outData
);

reg [533:0] shiftReg;

assign outData = shiftReg[511:0];

always @(posedge clk)
begin
    /*if(rst)
    shiftReg <=0;
    else
    begin*/
    if(load & shift)
    begin
        shiftReg[533:20] <= {2'b00,inData};
        shiftReg[19:0] <= {shiftReg[21:2]};
    end
    else if(load)
        shiftReg[533:0] <= {22'h0,inData};
    else if(shift)
        shiftReg <= {2'b00,shiftReg[533:2]};
  end
  //end
endmodule
