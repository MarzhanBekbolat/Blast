`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2018 10:59:35
// Design Name: 
// Module Name: HBlast
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


module HBlast(
input clk,
input rst,
input [31:0] data,
input [31:0] address,
input dataValid,
input [511:0] rdata,
input arready,
input rvalid,
output [31:0] araddres,
output arvalid,
output [7:0] arlength,
//output after expansion
output [31:0] locationStart,
output [31:0] locationEnd
 );
 
 
wire [511:0] querry;
wire querryValid; 
//slave 
wire [31:0] s_aradress;
//reg [7:0] s_arlength;
wire s_arvalid;
wire s_arready;
wire [511:0] s_rdata;
wire s_rvalid;


assign arlength = 8'b00001000; // How much should it be?

memInt memoryInt(
.clk(clk),
.rst(rst),
.ddr_rd_done(s_arready),
.ddr_rd(s_arvalid),
 .readAdd(s_aradress),
 .ddr_rd_valid(s_rvalid),
 .ddr_rd_data(s_rdata),
 //input for query
 .query(querry),
 .queryValid(querryValid),
 //ouput for comparator
 //input rdNew,
 //output [12:0] maxScoreOut,
 //output [31:0] outAddress,
 .locationStart(locationStart),
 .locationEnd(locationEnd),
 .hitTEST()
     );
 
 blastT queryB(
    .clk(clk),
    .data(data),
    .address(address),
    .dataValid(dataValid),
    .querry(querry),
    .querryValid(querryValid)
     );
 
 axi4_brdige AXi4(
     .clk(clk),
     .rst(rst),
     //slave
     .s_arvalid(s_arvalid),
     .s_araddr(s_aradress),
     .s_arlen(arlength),
     .s_rvalid(s_rvalid),
     .s_arready(s_arready),
     .s_rdata(s_rdata),
     //master
     .m_arvalid(arvalid),
     .m_araddr(araddres),
     .m_arlen(arlength),
     .m_arready(arready),
     .m_rvalid(rvalid),
     .m_rdata(rdata)
         );
endmodule
