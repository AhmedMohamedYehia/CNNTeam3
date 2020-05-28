//This module is responsible to add two floating points
//It can work either full precision or half precision based on dataWidth parameter

module Fp_Add 
#(parameter mantissaWidth = 23, parameter dataWidth = 32, parameter exponentWidth = 8)
(
input [(dataWidth-1):0] A_FP,  //Represents the first input of the floating point adder
input [(dataWidth-1):0] B_FP,  //Represents the second input of the floating point adder
output reg [(dataWidth-1):0] SUM_FP    //Represents the output of the floating point adder
);
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
reg  signTemp;
reg [(exponentWidth-1):0]expTemp;
reg  [mantissaWidth:0]mantissaTemp;
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
	    signTemp = sign_a;
	    expTemp = e_A;
	    mantissaTemp = fract_a;   
	    
	    sign_a = sign_b;
	    e_A = e_B;
	    fract_a =fract_b;
	    
	    sign_b = signTemp;
	    e_B = expTemp;
	    fract_b = mantissaTemp;
    end 
    

    
    shift_cnt = e_A - e_B;
    fract_b = fract_b >> shift_cnt;
    e_B = e_B + shift_cnt;
    
    if(fract_a>=fract_b)
    begin   
        sign=sign_a;
    end
    else
    begin
        sign=sign_b;
    end
    
    if (sign_a == sign_b)
    begin
        {cout,fract_c} = fract_a + fract_b;
        if(cout==1)
        begin
            fract_c = fract_c >> 1;
            e_B = e_B + 1;
        end
    end
    else
    begin
        fract_b = 24'b111111111111111111111111 - fract_b;
        //fract_b = 10'b1111111111 - fract_b;
        fract_b = fract_b +1;
        {cout,fract_c} = fract_a + fract_b;
        if(cout == 0)
        begin
            fract_c = 24'b111111111111111111111111 - fract_c;
            //fract_c = 10'b11111111111 - fract_c;
            fract_c = fract_c +1;
        end 
    end
    if ((sign_a==sign_b && cout==0) || sign_a != sign_b)
    begin
    for(i=(mantissaWidth+1); i>0 && fract_c[mantissaWidth]==0 ; i=i-1)
    begin
         fract_c = fract_c << 1;
         e_B = e_B - 1;
    end       
    end
    exponent = e_B;
    mantissa = fract_c[(mantissaWidth-1):0];
    SUM_FP = {sign,e_B,mantissa};   
    
	
end
endmodule
