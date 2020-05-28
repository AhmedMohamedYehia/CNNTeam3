//This module is responsible to multiply two floating points
//It can work either full precision or half precision based on dataWidth parameter
module Fp_Mul
#(parameter mantissaWidth = 23, parameter dataWidth = 32, parameter exponentWidth = 8, parameter biasing=127)
(
 input [(dataWidth-1):0]FP1,  //Represents the first input of the floating point multiplier  
 input [(dataWidth-1):0]FP2,    //Represents the first input of the floating point multiplier
 output reg [(dataWidth-1):0]FP_PRODUCT  //Represents the product of the floating point multiplier

 );
 reg [(exponentWidth-1):0]expReg;
 reg[(mantissaWidth*2+1):0] mul;
 reg[(mantissaWidth*2+1):0] mul2;
 reg sign;
 reg [(exponentWidth-1):0] exp;
 reg [(mantissaWidth-1):0]mantessa;
 integer i;
 integer flag;
 integer counter;
         
      
    always@(FP1 , FP2)
        begin
         flag =0;
   
         expReg[(exponentWidth-1):0]=FP1[(dataWidth-2):mantissaWidth]-biasing+FP2[(dataWidth-2):mantissaWidth];
         mul={1'b1,FP1[(mantissaWidth-1):0]}*{1'b1,FP2[(mantissaWidth-1):0]};
         mul2={1'b1,FP1[(mantissaWidth-1):0]}*{1'b1,FP2[(mantissaWidth-1):0]};
        if(mul[(mantissaWidth*2+1)]==1)
        begin
        expReg=expReg+1;
        mul=mul>>1;
        end  
        else
        begin 
        end 
        for(i=(mantissaWidth*2+1); i>0 && mul[(mantissaWidth*2+1)]==0 ; i=i-1)
        	begin
                    mul <= mul << 1;
			        expReg <= expReg-1;
        	end
	mantessa= mul[(mantissaWidth*2+1):(mantissaWidth+1)]<<1;    	             	            
    sign=FP1[(dataWidth-1)]^FP2[(dataWidth-1)];  
	exp=expReg;
	FP_PRODUCT = {sign, exp, mantessa};
    	end
	  
endmodule