

`timescale 1ns / 1ps
`define Period 10
`define testNum 1024
`define ddrAddrWidth 32
`define Querry 'h1234abcd



module tbMem();

reg clk;
reg rst;
wire ddr_rd_done;
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

reg [511:0] ddr [0:99];


initial
begin
   ddr[0] = {512{1'b1}};
   ddr[1] = {512{1'b1}};
   ddr[2] = {512{1'b1}};             
   ddr[3] = {512{1'b1}};
   ddr[4] = 'h1234abcd;//{512{1'b1}};
   ddr[5] = {512{1'b1}};
   ddr[6] = {512{1'b1}};
   ddr[7] = {{480{1'b1}},32'h1234abc0};
   ddr[8] = {{500{1'b1}},12'h123};
   ddr[9] = 'h1234abcd;
   ddr[10] = {512{1'b1}};
   ddr[11] = {512{1'b1}};
end
       
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
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
     rst = 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     queryValid <= 1'b1;
     query <= `Querry;
     @(posedge clk);
     queryValid <= 1'b0;
     /*wait(ddr_rd);///////
     @(posedge clk);
     queryValid <= 1'b0;
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
     @(posedge clk);
    ddr_rd_valid <= 1'b1;
     ddr_rd_data = 512'hc00;
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
         ddr_rd_data = 512'hca;
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
                 @(posedge clk); */
end


//integer ddrAddress = 0;
assign ddr_rd_done = ddr_rd;

/*always @(posedge clk)
begin
ddrAddress = readAdd /512;
end*/

always @(posedge clk)
begin
    if(ddr_rd)
    begin
        ddr_rd_valid <= 1'b1;
        ddr_rd_data <= ddr[readAdd /512];
        //ddrAddress <= ddrAddress + 1;
    end
    else
       ddr_rd_valid <= 1'b0;
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
