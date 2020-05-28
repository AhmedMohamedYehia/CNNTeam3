//This module is to calculate tanhx for the input x
//For simplicity tanhx = x + 1/3x^3 + 2/15x^5
module tanh
#(parameter mantissaWidth = 23, parameter dataWidth = 32, parameter exponentWidth = 8)
(
    input [(dataWidth-1):0]x,   //This represents the input of the module
    input clk,  //This represents the clk of the module
    input reset,
    output reg[(dataWidth-1):0]tanhx    //This represents the output of this module
 );
 
 //Register to hold x3 and 1/3*x3
 reg [(dataWidth-1):0]x3;
 //Register to hold x5 and 2/15*x5
 reg [(dataWidth-1):0]x5;
 
 //Variables for the multiplier 
 reg [(dataWidth-1):0]mul1; //First input for the multiplier
 reg [(dataWidth-1):0]mul2; //Second input for the multiplier
 wire [(dataWidth-1):0]mulResult;   //Output of the multiplier
 
 reg [(dataWidth-1):0]add1; //First input for the adder
 reg [(dataWidth-1):0]add2; //Second input for the adder
 wire [(dataWidth-1):0]addResult;   //Outfput of the adder
 
 //Counter to count which clock cycle are we in
 integer i=0;
 
 always @(posedge clk)
 begin
    if(reset == 1)
    begin
    end
    else if(i==0)
    begin
        mul1=x; //Assigning x to the multiplier input
        mul2=x; //Assigning x to the multiplier input
        i=i+1;      
    end
    else if(i==1)
    begin
        mul1=x3;    //Assigning x^2 to the multiplier input
        mul2=x;    //Assigning x to the multiplier input
        i=i+1;
       
    end
    else if(i==2)
    begin
        mul1=x3;    //Assigning x^3 to the multiplier input
        mul2=x;     //Assigning x to the multiplier input
        i=i+1;
    end
    else if(i==3)
    begin
        mul1=x5;    //Assigning x^4 to the multiplier input
        mul2=x;     //Assigning x to the multiplier input
        i=i+1;
    end
    else if(i==4)
    begin
        mul1=x3;    //Assigning x^3 to the multiplier input
        mul2=32'b00111110101010101010101010101011;  //Assigning 1/3 to the multiplier input
        i=i+1;
    end
    else if(i==5)
    begin
        mul1=x5;    //Assigning x^5 to the multiplier input
        mul2=32'b00111110000010001000100010001001;  //Assigning 2/15 to the multiplier input
        i=i+1;
    end
    else if(i==6)
    begin
        add1=x;     //Assigning x to the adding input
        add2=x3;    //Assigning 1/3*x^3 to the adding input
        i=i+1;
    end
    else if(i==7)
    begin
        add1=tanhx; //Assigning x+1/3*x^3 to the multiplier input
        add2=x5;    //Assigning 2/15*x^5 to the multiplier input
        i=i+1;
    end         
 end
 always @(negedge clk)
 begin
    if(i==1)
    begin
        x3=mulResult;   //Assigning the mulResult which is x^2 to reg x3
    end
    else if (i==2)
    begin
        x3=mulResult;   //Assigning the mulResult which is x^3 to reg x3
    end
    else if (i==3)
    begin
        x5=mulResult;   //Assigning the mulResult which is x^4 to reg x5
    end
    else if (i==4)
    begin
        x5=mulResult;   //Assigning the mulResult which is x^5 to reg x5
    end
    else if (i==5)
    begin
        x3=mulResult;   //Assigning the mulResult which is 1/3*x^3 to reg x3
    end
    else if (i==6)
    begin
        x5=mulResult;   //Assigning the mulResult which is 2/15*x^5 to reg x5
    end
    else if (i==7)
    begin
        tanhx=addResult;    //Assigning the addResult which is x+1/3*x^3 to reg tanhx
    end
    else if (i==8)
    begin
        tanhx=addResult;    //Assigning the addResult which is x+1/3*x^3+2/15*x^5 to reg tanhx
    end     

 end
 
 
 
 //The multiplier module
 Fp_Mul multiplier
 (
 .FP1(mul1),  //Represents the first input of the floating point multiplier  
 .FP2(mul2),    //Represents the first input of the floating point multiplier
 .FP_PRODUCT(mulResult)  //Represents the product of the floating point multiplier
  );
  
  //The adder module
  Fp_Add adder 
  (
  .A_FP(add1),  //Represents the first input of the floating point adder
  .B_FP(add2),  //Represents the second input of the floating point adder
  .SUM_FP(addResult)    //Represents the output of the floating point adder
  );
endmodule
