`timescale 1ns / 1ps
`define Period 10
`define testNum 1024


module tbE();

    reg clk;
    reg rst;
    reg start;
    reg queryValid;    
    reg dataValid;
    reg[8:0] shiftNo;
    reg[16:0] dataCounter;
    reg[511:0] inQuery;
    reg [8:0] LocationQ;
    reg [511:0]inDB;
       
    wire load;
    reg loadDone;
    wire [31:0] outAddress;
    wire [31:0] locationStart;
    wire [31:0] locationEnd;
    wire stop;
       
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
    rst = 1'b1;
    start = 1'b0;

     #50;
     rst = 1'b0;
     #50
     @(posedge clk);
     queryValid <= 1'b1;
     LocationQ = 9'h28;
     inQuery <= 512'hfff;
     @(posedge clk);
     queryValid <= 1'b0;
     @(posedge clk);
     start <= 1'b1;
     shiftNo <= 9'ha;
     dataCounter <= 17'b1 ;
     @(posedge clk);
     wait(load);///////
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     loadDone <= 1'b1;
     @(posedge clk);
     loadDone <= 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     dataValid <= 1'b1;
     inDB = 512'h0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     wait(load);///////
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     loadDone <= 1'b1;
     @(posedge clk);
     loadDone <= 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     dataValid <= 1'b1;
     inDB = 512'h0;
     wait(stop);
     $stop;
end

ExpandFSM exp(
    .clk(clk),
    .rst(rst),
    .start(start),
    .queryValid(queryValid),    
    .dataValid(dataValid),
    .shiftNo(shiftNo),
    .dataCounter(dataCounter),
    .inQuery(inQuery),
    .LocationQ(LocationQ),
    .inDB(inDB),
       
    .load(load),
    .loadDone(loadDone),
    .outAddress(outAddress),
    .locationStart(locationStart),
    .locationEnd(locationEnd),
    .stop(stop)
    );
endmodule