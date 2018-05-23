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


module topModule(
input [511:0] query,
input queryValid,
input [511:0] dataBase,
input dataBaseValid,
input clk,
input rst,
output hSP,
output  reg [8:0] location
    );
    
integer counter=0;
 wire [803:0] ouput;
 reg [5:0] maxScore = 0;
 wire [21:0] dBCompareWmer;
 wire [511:0] dbShiftRegOut;
 reg [511:0] queryReg;
 
 
 always @(posedge clk)
 if(queryValid)
     queryReg <=  query;
 
 assign dBCompareWmer = dbShiftRegOut[511:490];
 
 always @(posedge clk) 
 begin
 if(!rst)
 counter <= counter+2;
 end 

integer k;
always @(posedge clk)
begin
if(rst)
begin
maxScore <=0;
location <=0;
end 
else
begin
for ( k=0; k<799; k= k+6)
begin
if(ouput[k+:6]>maxScore)
begin
maxScore <= ouput[k+:6];
location <= k/3;
end
end
end
 end
 
 
 
 genvar i;
 generate 
 for(i =0; i<491; i =i+2)
 begin: comparator
 Comparator c1(
    .clk(clk),
    .rst(rst),
    .inQuery(queryReg[i+:22]),
    .inDB(dBCompareWmer),
    .score(ouput[i+:6])
        );
  end
 endgenerate
 
 
 shift2Reg dbShiftReg(
 .clk(clk),
 .rst(rst),
 .load(),
 .shift(),
 .inData(),
 .outData(dbShiftRegOut)
 );
 
endmodule
