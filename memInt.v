`timescale 1ns / 1ps
`define ddrAddrWidth 32
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2018 16:08:57
// Design Name: 
// Module Name: memInt
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


module memInt(
input clk,
input rst,
input ddr_rd_done,
output reg ddr_rd,
output reg [`ddrAddrWidth-1:0] readAdd,
input ddr_rd_valid,
input [511:0] ddr_rd_data,
//input for query
input [511:0] query,
input queryValid,
//ouput for comparator
//input rdNew,
//output [10:0] maxScoreOut,
//output [31:0] outAddress,
output [31:0] locationStart,
output [31:0] locationEnd,
output hitTEST
    );
    
 //From memory interface to expand
 reg [16:0] DataCounter;
 reg [511:0] queryReg;
 reg [2:0] state;
 // Hit input
 reg queryValidQ;
 reg shift;
 reg load;
 reg [511:0] dbHit;
 //hit output
 wire hit;
 wire [8:0] ShiftNo;
 wire [8:0] locationQ; 
 //Expand
 wire loadExpOut;
 reg queryValidReg;
 reg [8:0] locationQReg; 
 reg hitReg;
 wire [8:0] ShiftNoReg;
 reg loadDone;
 //reg ready;
 reg queryValidExp;
 reg [511:0] dbExpand;  
 wire stop;
 reg dbValid;
 assign hitTEST = hit;
 localparam IDLE = 3'b000,
            WAIT = 3'b001,
            SHIFT = 3'b011,
            SHIFTLOAD =3'b100,
            WAIT_EXP = 3'b010,
            WAIT_HIT = 3'b101;
 assign ShiftNoReg = ShiftNo;
 always @(posedge clk)
 begin
    if(queryValid)
    queryReg <= query;
 end
 
 
 always @(posedge clk)
 begin
 if(rst)
    begin
    queryValidExp <=1'b0;
    queryValidQ <= 1'b0;
    ddr_rd <= 0;
    readAdd <=0;
    DataCounter <=0;
    state <= IDLE;
    end
   else 
     begin
     queryValidQ <=1'b1;
     case (state)
     IDLE: begin
     /*if(!hit)
        begin
        if(ShiftNo ==0)
                     begin
                     load <= 1'b0;
                     DataCounter <= DataCounter +1;
                     ddr_rd <= 1'b1;
                     readAdd <= (DataCounter +1)*512; 
                     state <= WAIT;
                     //dbHit <= ddr_rd_data;
                     shift <=1'b0;
                     end  
        else if (ShiftNo != 0 & (ShiftNo % 512 != 0))
                     begin
                     shift <=1;
                     end
        else if (ShiftNo % 512 == 0)
                     begin
                      DataCounter <= DataCounter +1; //Do I need new register to DataCounter?
                      ddr_rd <= 1'b1;
                      readAdd <= (DataCounter +1)*512; 
                      state <= WAIT;
                      //dbHit <= ddr_rd_data;
                     load <= 0;
                     shift <=0;
                     end
        end
     else*/ if(hit & !stop)
             begin
             hitReg <= 1'b1;
             locationQReg <= locationQ;
             if(loadExpOut)
             begin
             //queryValidExp <= 1'b1;
             ddr_rd <= 1'b1;
             readAdd <= outAddress; 
             state <= WAIT_EXP;
             end
             //dbExpand <= ddr_rd_data;
             shift = 1'b0;
             load = 1'b0;
             end
        else 
         begin
         if(DataCounter==0)
         begin
          if(ShiftNo ==0)
                                    begin
                                    load <= 1'b0;
                                    //DataCounter <= DataCounter +1;
                                    ddr_rd <= 1'b1;
                                    readAdd <= DataCounter*512; 
                                    state <= WAIT;
                                    //dbHit <= ddr_rd_data;
                                    shift <=1'b0;
                                    end  
                       else if (ShiftNo != 0 & (ShiftNo % 490 != 0))
                                    begin
                                    shift <=1'b0;
                                    state<= WAIT_HIT;
                                    end
                       else if (ShiftNo % 490 == 0)
                                    begin
                                     DataCounter <= DataCounter +1; //Do I need new register to DataCounter?
                                     ddr_rd <= 1'b1;
                                     readAdd <= (DataCounter +1)*512; 
                                     state <= WAIT;
                                     //dbHit <= ddr_rd_data;
                                    load <= 0;
                                    shift <=0;
                                    end
         end
         else 
            begin
               if(ShiftNo ==0)
                            begin
                            load <= 1'b0;
                            //DataCounter <= DataCounter +1;
                            ddr_rd <= 1'b1;
                            readAdd <= DataCounter*512; 
                            state <= WAIT;
                            //dbHit <= ddr_rd_data;
                            shift <=1'b0;
                            end  
               else if (ShiftNo != 0 & (ShiftNo % 512 != 0))
                            begin
                            shift <=1'b0;
                            state<= WAIT_HIT;
                            end
               else if (ShiftNo % 512 == 0)
                            begin
                             DataCounter <= DataCounter +1; //Do I need new register to DataCounter?
                             ddr_rd <= 1'b1;
                             readAdd <= (DataCounter +1)*512; 
                             state <= WAIT;
                             //dbHit <= ddr_rd_data;
                            load <= 0;
                            shift <=0;
                            end
               end
         end
      end
      WAIT: begin
        ddr_rd <=1'b0;
        if(ddr_rd_valid & ddr_rd_done)
        begin
          dbValid <= 1'b1;
          dbHit <= ddr_rd_data;
          load <= 1'b1;
          state <= SHIFT;
        end
      end
      SHIFT: begin
        shift <= 1'b1;
      load <= 1'b0;
      state <= SHIFTLOAD;
      end
      SHIFTLOAD: begin
      shift <= 1'b0;
      state <= IDLE;
      end
     WAIT_EXP: begin
              if(ddr_rd_valid & ddr_rd_done)
              begin
                loadDone <= 1'b1;
                queryValidExp <= 1'b1;
                dbExpand <= ddr_rd_data;
                ddr_rd <=1'b0;
                if(stop)
                state <= IDLE;
              end
            end
            WAIT_HIT: begin
            if(!hit)
            begin
            shift <=1'b1;
            state <= IDLE;
            end
           
            end
     endcase
     end
 end 
 

   
 Hit hitMem(
    .clk(clk),
    .rst(rst),
    //only once
    .query(queryReg),
    .queryValid(queryValidQ),
    //data from ddr
    .dataBase(dbHit),  //dataBase 
    .dataBaseValid(dbValid),
    .shift(shift),
    .load(load),
    .stop(stop),
    //output
    .ShiftNo(ShiftNo),
    .hit(hit),
    .locationQ(locationQ)
        );
        
        
    ExpandFSM Expand(
    .clk(clk),
    .rst(rst),
    .start(hitReg), // May be in next state
    .queryValid(queryValidReg),    
    .dataValid(queryValidExp),
    //.ready(ready),
    .shiftNo(ShiftNoReg),
    .dataCounter(DataCounter),
    .inQuery(queryReg),
    .LocationQ(locationQReg),
    .inDB(dbExpand), //dataBase 
               
    .load(loadExpOut),
    .loadDone(loadDone),
    .outAddress(outAddress),
    .locationStart(locationStart),
    .locationEnd(locationEnd),
    .stop(stop)
            );
endmodule
