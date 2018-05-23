`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2018 18:38:30
// Design Name: 
// Module Name: topComparator
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

module Comparator(
input clk,
input rst,
input [21:0] inQuery,
input [21:0] inDB,
output  [5:0] score
    );
  
reg [6:0] scoreCalc =0;   
  
assign  score = $signed(scoreCalc) <= 0 ? 0 : scoreCalc;
    
  
 always @(posedge clk) 
 begin
 if(rst)
  scoreCalc = 0;
 else
 begin
     scoreCalc = 0;  
     
     
     /*
     if two/three consecuetive bases are mismatched 
     signed or unsigned 
     
     */
  if( inQuery[21:20] == inDB[21:20])
        scoreCalc = $signed(scoreCalc) + 5;
    else 
        scoreCalc = scoreCalc - 4;
  if( inQuery[19:18] == inDB[19:18])
                scoreCalc = scoreCalc + 5;
            else 
                scoreCalc = scoreCalc - 4;
   if( inQuery[17:16] == inDB[17:16])
                        scoreCalc = scoreCalc + 5;
                    else 
     scoreCalc = scoreCalc - 4;  
    if( inQuery[15:14] == inDB[15:14])
                             scoreCalc = scoreCalc + 5;
                         else 
          scoreCalc = scoreCalc - 4;    
    if( inQuery[13:12] == inDB[13:12])
                                  scoreCalc = scoreCalc + 5;
                              else 
               scoreCalc = scoreCalc - 4;  
     if( inQuery[11:10] == inDB[11:10])
                                       scoreCalc = scoreCalc + 5;
                                   else 
                    scoreCalc = scoreCalc - 4; 
    if( inQuery[9:8] == inDB[9:8])
                                            scoreCalc = scoreCalc + 5;
                                        else 
                         scoreCalc = scoreCalc - 4;    
      if( inQuery[7:6] == inDB[7:6])
          scoreCalc = scoreCalc + 5;
         else 
         scoreCalc = scoreCalc - 4;               
     if( inQuery[5:4] == inDB[5:4])
                  scoreCalc = scoreCalc + 5;
                 else 
                 scoreCalc = scoreCalc - 4;
      if( inQuery[3:2] == inDB[3:2])
                                  scoreCalc = scoreCalc + 5;
                                 else 
                                 scoreCalc = scoreCalc - 4;  
       if( inQuery[1:0] == inDB[1:0])
                                                  scoreCalc = scoreCalc + 5;
                                                 else 
                                                 scoreCalc = scoreCalc - 4;                
   // score <= scoreCalc;
  end
 end   
endmodule
