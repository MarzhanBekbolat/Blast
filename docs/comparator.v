module comparator(
input clk,
input rst,
input stop,
input dbValid,
input [21:0] inQuery,
input [21:0] inDB,
output reg isMatch
    );
  
   
always @(posedge clk) 
 begin
 if(rst)
 isMatch <= 0;
 else if(stop) 
 begin
   isMatch <= 0;
 end
 else if(dbValid)
 begin
    if(inQuery == inDB)
      isMatch <= 1;
   else 
      isMatch <= 0;
  end
end
endmodule 