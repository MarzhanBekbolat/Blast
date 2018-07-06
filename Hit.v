`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2018 11:29:54
// Design Name: 
// Module Name: topModule
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


module Hit(
input clk,
input rst,
//only once
input [511:0] query,
input queryValid,
//data from ddr
input [511:0] dataBase,
input dataBaseValid,
input shift,
input load,
input stop,
input [31:0] locationEnd,
//output
output [8:0] ShiftNo,
output reg hit,
output [8:0] locationQ
    );
  localparam IDLE = 1'b0,
             HITLOW = 1'b1;  
 reg state;
 wire [21:0] dBCompareWmer;
 wire [511:0] dbShiftRegOut;
wire [245:0] ouput;
 reg [8:0] CurrentLocation; 
 reg [511:0] queryReg; 
 //for output of comparators
 reg [8:0] ShiftNoIn=0; 
 reg [8:0] k;
   
 always @(posedge clk)
 begin
  if(queryValid)
      queryReg <=  query;
 end
 
 
 assign locationQ = CurrentLocation;
 assign dBCompareWmer = dbShiftRegOut[21:0];  //changed
 assign ShiftNo = ShiftNoIn; 
 
 
 always @(posedge clk) 
   begin
  if (shift)// if(shift)
   begin
    ShiftNoIn <= ShiftNoIn+2;
  end 
  else if (stop)
    ShiftNoIn <= locationEnd;
 end

// At each clk find max of comparatpr outputs
always @(posedge clk)
    begin
     if(rst)
        begin
        CurrentLocation <=0;
        hit <=0;
        state <=IDLE;
        end 
     else 
       begin
       case(state)
       IDLE: begin
       if(dataBaseValid)
       begin
         for(k=0; k<246; k= k+1)
         begin
         if(ouput[k]==1)
             begin
             hit <=1;
             CurrentLocation <= k*2;
             k=246;
             state <=HITLOW;
             end
         end
         end
        end
        HITLOW: begin
         if(stop)
         begin
         hit <=0;
         k=0;
         state <=IDLE;
         end
        end
        endcase
      end
   end

 
 //generate 246 comparators
 genvar i;
 generate 
 for(i =0; i<491; i =i+2)
 begin: compare
 comparator c1(
    .clk(clk),
    .rst(rst),
    .stop(stop),
    .dbValid(dataBaseValid),
    .inQuery(queryReg[i+:22]),
    .inDB(dBCompareWmer),
    .isMatch(ouput[i/2])
        );
  end
 endgenerate
 

 //shift by two bits, load if new data needed
 shift2Reg dbShiftReg(
 .clk(clk),
 .rst(rst),
 .load(load),
 .shift(shift),
 .ShiftNo(ShiftNoIn),
 .stop(stop),
 .inData(dataBase),
 .dataValid(dataBaseValid),
 .outData(dbShiftRegOut)
 );


 
endmodule
