//This module is responsible to add two floating points
//It can work either full precision or half precision based on dataWidth parameter

module Fp_Add 
#(parameter mantissaWidth = 23, parameter dataWidth = 32, parameter exponentWidth = 8)
(
input [(dataWidth-1):0] A_FP,  //Represents the first input of the floating point adder
input [(dataWidth-1):0] B_FP,  //Represents the second input of the floating point adder
output reg [(dataWidth-1):0] SUM_FP    //Represents the output of the floating point adder
);
   //Total data width
   //Mantissa data width
    //Exponent data width
//variables used in an always block
//are declared as registers
reg sign_a, sign_b,sign_c;
reg [(exponentWidth-1):0] e_A, e_B;
reg [mantissaWidth:0] fract_a, fract_b,fract_c;//frac = 1 . mantissa 
reg [(exponentWidth-1):0] shift_cnt;
reg cout;
reg  sign; 
reg [(exponentWidth-1):0] exponent; 
reg [(mantissaWidth-1):0] mantissa;
integer i;

always @ (A_FP , B_FP)
begin
	sign_a  = A_FP [(dataWidth-1)];
	sign_b  = B_FP [(dataWidth-1)];
	e_A      = A_FP [(dataWidth-2):mantissaWidth];
	e_B      = B_FP [(dataWidth-1):mantissaWidth];
	fract_a  = {1'b1,A_FP [(mantissaWidth-1):0]};
	fract_b  = {1'b1,B_FP [(mantissaWidth-1):0]};
	//align fractions
	if (e_A < e_B)
    begin
	   shift_cnt  = e_B - e_A;
       fract_a   = fract_a >> shift_cnt;
       e_A   = e_A + shift_cnt;      
    end 
    
	if (e_B < e_A)
    begin
		shift_cnt  = e_A - e_B;
    	fract_b  = fract_b >> shift_cnt;
	    e_B  = e_B + shift_cnt;
    end 
    
    
    //Calculating the sign of the output floating point
    if(fract_a >= fract_b)
    begin
        sign=sign_a;
    end
    else
    begin
        sign=sign_b;
    end
    
    
	//Adding both fractions
	if(sign_a == sign_b) 
	   begin
	       {cout, fract_c}  = fract_a + fract_b;
	       //Normalizing the result
            if (cout == 1)
                begin
                  {cout, fract_c}  = {cout, fract_c} >> 1;
                  e_B  = e_B + 1;
                end
	   end
	else
	   begin
	      if(sign_a && !sign_b)
              begin
              
                  fract_b = 24'b111111111111111111111111 - fract_b;
                  //fract_b = 11'b11111111111 - fract_b;
                  
                  fract_b = fract_b + 1;
                  {cout, fract_c}  = fract_a + fract_b;
              end
           else
              begin
                  fract_a = 24'b111111111111111111111111 - fract_a;
                  //fract_a = 11'b11111111111 - fract_a;
                  fract_a = fract_a + 1;
                  {cout, fract_c}  = fract_a + fract_b;
              end
              
          if (cout == 0)
          begin
                    fract_c = 24'b111111111111111111111111 - fract_c;
                    //fract_c = 11'b11111111111 - fract_c;
                    fract_c = fract_c + 1;
                    for(i=(mantissaWidth*2+1); i>0 && fract_c[mantissaWidth]==0 ; i=i-1)
                                   begin
                                        fract_c <= fract_c << 1;
                                        e_B <= e_B - 1;
                                   end
                    fract_c <= fract_c << 1;
                    e_B <= e_B - 1;               
          end
          else         
              begin
              end
         
	 end   
	exponent  = e_B;
	mantissa  = fract_c[(mantissaWidth-1):0];
	SUM_FP = {sign, exponent, mantissa};
	
	
end
endmodule
