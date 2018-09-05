`timescale 1ns / 1ps

module highScore(
       input clk,
       input rst,
       input [1:0] b1,
       input [1:0] b2,
       input startCalc,
       output [10:0] Score
    );
    
    reg [10:0] highScore;
    assign Score = highScore;
    
    always @(posedge clk)
    begin
    if(rst)
      highScore <= 55;
    else if(startCalc)
    begin
      if(b1 != 2 & b2 != 2)
       begin
          if(b1 == 1 & b2 == 1)
            highScore = highScore + 10;
          else 
            highScore = highScore + 1;    
       end 
     else 
       highScore = highScore + 5;
    end
    end
    
    
      
endmodule
