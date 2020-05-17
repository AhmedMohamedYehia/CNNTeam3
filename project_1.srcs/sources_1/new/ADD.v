module Fp_Add (
input [31:0] A_FP, 
input [31:0] B_FP,
output reg  sign, 
output reg [7:0] exponent, 
output reg [22:0] mantissa);

//variables used in an always block
//are declared as registers
reg sign_a, sign_b,sign_c;
reg [7:0] e_A, e_B;
reg [23:0] fract_a, fract_b,fract_c;//frac = 1 . mantissa 
reg [7:0] shift_cnt;
reg cout;
integer i;

always @ (A_FP , B_FP)
begin
	sign_a  = A_FP [31];
	sign_b  = B_FP [31];
	e_A      = A_FP [30:23];
	e_B      = B_FP [30:23];
	fract_a  = {1'b1,A_FP [22:0]};
	fract_b  = {1'b1,B_FP [22:0]};
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
    
    
    //Handling the sign
    if(fract_a >= fract_b)
    begin
        sign=sign_a;
    end
    else
    begin
        sign=sign_b;
    end
    
    
	//add fractions
	if(sign_a == sign_b) 
	   begin
	       {cout, fract_c}  = fract_a + fract_b;
	       //normalize result
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
                  fract_b = fract_b + 1;
                  {cout, fract_c}  = fract_a + fract_b;
              end
           else
              begin
                  fract_a = 24'b111111111111111111111111 - fract_a;
                  fract_a = fract_a + 1;
                  {cout, fract_c}  = fract_a + fract_b;
              end
              
          if (cout == 0)
          begin
                    fract_c = 24'b111111111111111111111111 - fract_c;
                    fract_c = fract_c + 1;
                    for(i=47; i>0 && fract_c[23]==0 ; i=i-1)
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
	mantissa  = fract_c[22:0];
	
	
end
endmodule
