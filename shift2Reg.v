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
input [8:0] ShiftNo,
input stop,
input hit,
input [511:0] inData,
input dataValid,
output [511:0] outData
);

reg [533:0] shiftReg;
 reg [8:0] k=0;
 reg [8:0] ShiftNoReg;
 reg state=0;
assign outData = shiftReg[511:0];


 localparam IDLE = 1'b0,
             WAIT_SHIFT = 1'b1; 
always @(posedge clk)
begin
if( stop & hit)
ShiftNoReg <= ShiftNo;
end

always @(posedge clk)
begin
case(state)
  IDLE: begin
    if(stop)
    begin
   state <=WAIT_SHIFT;
    end
    else
    begin
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
  end
  WAIT_SHIFT: begin
  for(k=0; k<ShiftNo-ShiftNoReg; k=k+1)
     begin
     shiftReg <= {2'b00,shiftReg[533:2]};
     end
  state <= IDLE;
  end
  endcase
  end
endmodule
