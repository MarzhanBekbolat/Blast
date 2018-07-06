`timescale 1ns / 1ps
`define th 200

   module ExpandFSM(
    input clk,
    input rst,
    input start,
    input queryValid,    
    input dataValid,
    //input ready,
    input [8:0] shiftNo,
    input [16:0] dataCounter,
    input [511:0] inQuery,
    input [8:0] LocationQ,
    input [511:0]inDB,
       
    output reg load,
    input  loadDone,
    output [31:0] outAddress,
    output reg [31:0] locationStart,
    output reg [31:0] locationEnd,
    output reg stop
    );
    
    reg [9:0] shiftNumber;
    reg [511:0] dataSet1;
    reg [511:0] dataSet2;
    reg [31:0] addressCalc;
    reg [1023:0] dataMerged;
    reg [511:0] Query;
    reg [2:0] state;
         
    wire [8:0] range1;
    wire [8:0] range2;
    reg [8:0] k1=0;
    reg [8:0] k2=0;
    reg [8:0] i1;
    reg [8:0] i2;
    reg [9:0] m1;
    reg [9:0] m2;
    
    localparam IDLE = 3'b000,
               LOAD1 = 3'b001,
               LOAD2 = 3'b010,
               EXPAND = 3'b011,
               WAIT   = 3'b100,
               MERGE  = 3'b101;
    
    assign outAddress = addressCalc;
    //assign difference = shiftNumber >= LocationQ ? (shiftNumber - LocationQ) : (LocationQ - shiftNumber);   
    assign  range1 = LocationQ <= `th ? LocationQ : `th;    
    assign  range2 = (512 - (LocationQ + 22)) <= `th ? (512 - (LocationQ + 22)) : `th;   
        
    always @(posedge clk)
    begin
        if(rst)
        begin
            state <= IDLE;
            load = 1'b0;
            stop =  1'b0;
        end
        else
        begin
            case(state)
                IDLE:begin 
                    stop <= 1'b0;
                    shiftNumber = shiftNo;  
                    addressCalc = dataCounter * 512 + shiftNumber;
                    i1 <= LocationQ;
                    i2 <= LocationQ + 21;
                    m1 <= dataCounter * 512 + shiftNumber;
                    m2 <= dataCounter * 512 + shiftNumber + 21;
                    locationStart <= dataCounter * 512 + shiftNumber;
                    locationEnd <= dataCounter * 512 + shiftNumber + 21;
                    if(queryValid)
                        Query <= inQuery;
                    if(!stop & start)
                    begin
                        state <= WAIT;
                        load <= 1'b1;
                    end
                end
                WAIT:begin
                     if(loadDone)
                     begin
                        load <= 1'b0;
                        state <= LOAD1;
                     end
                end
                LOAD1:begin
                    if(dataValid)
                    begin
                        if(dataCounter == 0 & shiftNumber < 199)
                        begin
                            dataMerged[511:0] <= inDB;
                            dataMerged[1023:512] <= 512'h0;
                            state <= EXPAND;
                        end    
                        else if(shiftNumber < 199)
                         begin
                            dataMerged[1023:512] <= inDB;
                            state <= LOAD2;
                         end
                         else if(shiftNumber > 290)
                         begin
                            dataMerged[511:0] <= inDB;
                            state <= LOAD2;
                         end 
                         else
                         begin
                            dataMerged[511:0] <= inDB;
                            dataMerged[1023:512] <= 512'h0;
                            state <= EXPAND;
                         end
                    end
                end
                LOAD2:begin
                    load <= 1'b1; 
                    if(shiftNumber < 199)
                    begin
                       addressCalc <= addressCalc - 512; // ????????????????????????????????????????????????????????????    
                    end
                    else if(shiftNumber > 290)
                    begin
                        addressCalc <= addressCalc + 512; //?????????????????????????????????????????????????????????????               
                    end          
                    if(loadDone)
                    begin
                        load <= 1'b0;
                        state <= MERGE;
                    end 
                        
                end
                
                MERGE:begin
                    if(dataValid)
                    begin
                        if(shiftNumber < 199)
                        begin
                             shiftNumber <= shiftNumber + 512; //             
                             dataMerged[511:0] <= inDB;                       
                        end
                        else if(shiftNumber > 290)
                        begin
                             dataMerged[1023:512] <= inDB;               
                        end
                        state <= EXPAND;
                    end
                end
                
                EXPAND:begin
                        if(dataMerged[m1-:2] != Query[i1-:2] & dataMerged[m2+:2] != Query[i2+:2]) 
                        begin
                            stop <= 1'b1;
                            k1=0;
                            k2=0;
                            state <= IDLE;
                        end
                        else if(k1 == range1 & k2 == range2)
                        begin
                            k1=0;
                            k2=0;
                            stop <= 1'b1;
                            state <= IDLE;
                        end
                        else 
                        begin
                            if(k1 != range1)
                            begin
                              stop <= 1'b0;
                              k1 <= k1 + 2;
                              m1 <= m1 -2;
                              i1 <= i1 - 2; 
                              if(dataMerged[m1-:2] == Query[i1-:2]) 
                                   locationStart <= locationStart - 2;
                            end
                            //else if(k1 == range1)
                            if(k2 != range2)
                            begin
                                stop <= 1'b0;
                                k2 <= k2 + 2;
                                m2 <= m2 + 2;
                                i2 <= i2 + 2; 
                                if(dataMerged[m2+:2] == Query[i2+:2]) 
                                   locationEnd  <= locationEnd + 2;
                            end    
                        end        
                end
            endcase
        end
    end        

    
    endmodule
