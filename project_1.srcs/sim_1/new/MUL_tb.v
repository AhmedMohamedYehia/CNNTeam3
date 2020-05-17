
///////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2020 03:18:13 PM
// Design Name: 
// Module Name: FPMU
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


module FPMU1(
 input [31:0]FP1,
 input [31:0]FP2,
 output reg sign,
 output reg [7:0] exp,
 output reg [22:0]mantessa
 );
 reg [7:0]expReg;
 reg[47:0] mul;
 reg[47:0] mul2;
 integer i;
 integer flag;
 integer counter;
         
      
    always@(FP1 , FP2)
        begin
         flag =0;
   
         expReg[7:0]=FP1[30:23]-127+FP2[30:23];
         mul={1'b1,FP1[22:0]}*{1'b1,FP2[22:0]};
         mul2={1'b1,FP1[22:0]}*{1'b1,FP2[22:0]};
        if(mul[47]==1)
        begin
        expReg=expReg+1;
        mul=mul>>1;
        end  
        else
        begin 
        end 
        for(i=47; i>0 && mul[47]==0 ; i=i-1)
        	begin
                    mul <= mul << 1;
			        expReg <= expReg-1;
        	end
	mantessa= mul[47:24]<<1;    	             	            
    sign=FP1[31]^FP2[31];  
	exp=expReg;
    	end
	  
endmodule