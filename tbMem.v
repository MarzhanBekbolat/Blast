

`timescale 1ns / 1ps
`define Period 10
`define testNum 1024
`define ddrAddrWidth 32


module tbMem();

reg clk;
reg rst;
reg ddr_rd_done;
wire ddr_rd;
wire [`ddrAddrWidth-1:0] readAdd;
reg ddr_rd_valid;
reg [511:0] ddr_rd_data;
//input for query
reg [511:0] query;
reg queryValid;
//ouput for comparator
//input rdNew,
//output [10:0] maxScoreOut,
//output [31:0] outAddress,
wire [31:0] locationStart;
wire [31:0] locationEnd;
wire hitTEST;
       
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
    //start = 1'b0;
    @(posedge clk);
     rst = 1'b0;
     @(posedge clk);
     queryValid <= 1'b1;
     query <= 512'hfff;
     wait(ddr_rd);///////
     @(posedge clk);
     queryValid <= 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
    ddr_rd_valid <= 1'b1;
     ddr_rd_data = 512'hc0;
     @(posedge clk);
     @(posedge clk);
     ddr_rd_done <= 1'b1;
     @(posedge clk);
    ddr_rd_valid <= 1'b0;
    ddr_rd_done <= 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     wait(ddr_rd);///////
     wait(hitTEST);
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
        ddr_rd_valid <= 1'b1;
         ddr_rd_data = 512'h11;
         @(posedge clk);
         @(posedge clk);
         ddr_rd_done <= 1'b1;
         @(posedge clk);
        ddr_rd_valid <= 1'b0;
        ddr_rd_done <= 1'b0;
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
         @(posedge clk);
          wait(ddr_rd);///////
             @(posedge clk);
             queryValid <= 1'b0;
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
            ddr_rd_valid <= 1'b1;
             ddr_rd_data = 512'hc0;
             @(posedge clk);
             @(posedge clk);
             ddr_rd_done <= 1'b1;
             @(posedge clk);
            ddr_rd_valid <= 1'b0;
            ddr_rd_done <= 1'b0;
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
             @(posedge clk);
              wait(ddr_rd);///////
                 @(posedge clk);
                 queryValid <= 1'b0;
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                ddr_rd_valid <= 1'b1;
                 ddr_rd_data = 512'hc0;
                 @(posedge clk);
                 @(posedge clk);
                 ddr_rd_done <= 1'b1;
                 @(posedge clk);
                ddr_rd_valid <= 1'b0;
                ddr_rd_done <= 1'b0;
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk);
                 @(posedge clk); 
end



memInt MEmory(
.clk(clk),
.rst(rst),
.ddr_rd_done(ddr_rd_done),
.ddr_rd(ddr_rd),
.readAdd(readAdd),
.ddr_rd_valid(ddr_rd_valid),
.ddr_rd_data(ddr_rd_data),
//input for query
.query(query),
.queryValid(queryValid),
//ouput for comparator
//output [31:0] outAddress,
.locationStart(locationStart),
.locationEnd(locationEnd),
.hitTEST(hitTEST)
    );
    
endmodule
