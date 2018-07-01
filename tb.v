`timescale 1ns / 1ps
`define Period 10
`define memSize 4294967296 //4GB
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.05.2018 20:51:46
// Design Name: 
// Module Name: tb
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


module tb( );
reg clk;
reg rst;
reg [511:0] query;
reg queryValid;
reg [511:0] dataBase;
//reg dataBaseValid;
reg shift;
reg dataBaseValid;
reg load;
integer count=0;
wire hit;
wire [8:0] ShiftNo;
wire [8:0] locationQ;

initial
begin
    clk = 0;
    forever
    begin
        clk = ~clk;
        #(`Period/2);
    end
end

initial
begin
  rst <=1;
  queryValid <=0; 
  shift <=0;
  load <=0;
  #200
  rst <=0;
  @(posedge clk);
  queryValid <=1'b1;
  query <= 512'hfff;
  load <=1'b1;
  dataBase <= 512'h11;
 dataBaseValid =1; 
 @(posedge clk);
  load <=1'b0;
  
end

always @(posedge clk)
begin
if(rst)
begin
dataBase <= 512'h11;
query <= 512'hfff;
queryValid <=0; 
  shift <=0;
  load <=0;
end
else 
begin
   queryValid <=1'b1;
   if(hit)
   begin
   queryValid <=1'b0;
   shift = 1'b0;
   load = 1'b0;
   end
    else if(ShiftNo ==0)
   begin
   if(count !=0 & !hit) //load <= 1;
   shift <=1'b1;
   else
   shift <=1'b0;
   end  
   else if (ShiftNo != 0 & (ShiftNo % 512 != 0))
   begin
   shift <=1;
   end
   else if (ShiftNo % 512 == 0)
   begin
   load <= 1;
   shift <=1;
   end
end
end

always @(posedge clk)
begin
count <= count +1;
end

Hit hitTB(
.clk(clk),
.rst(rst),
//only once
.query(query),
.queryValid(queryValid),
//data from ddr
.dataBase(dataBase),
.dataBaseValid(dataBaseValid),
.shift(shift),
.load(load),
//output
.ShiftNo(ShiftNo),
.hit(hit),
.locationQ(locationQ)
    );
endmodule
