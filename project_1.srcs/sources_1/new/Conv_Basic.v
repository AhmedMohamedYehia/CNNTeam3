`timescale 1 ns / 1 ns
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 28.05.2020 13:42:20
// Design Name: PART 1 - (a)
// Module Name: Conv_Basic
// Project Name: CNN Final Assesment
//////////////////////////////////////////////////////////////////////////////////

//THIS MODULE TAKES PART OF AN IMAGE ARRAY 5*5 [imageArray] AND A FILTER 5*5 MATRIX [filterArray]
//PERFORMING CONVOLUTION OPERATION
//REULTS ONLY 1 ELEMENT [convOut]
module Conv_Basic(clk,imageArray,filterArray,convOut,reset);

parameter ROWSIZE =5;//The row size
parameter COLUMNSIZE =5;//The column size
parameter DATAWIDTH =32; //data width of each number either 16 or 32
parameter LAST_ADDITION =2; //depends on the size of the filter 

input clk;//The clock for the system
input [31:0] imageArray [4:0][4:0];
//input [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] imageArray; //Vector for the image matrix numbers
input [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] filterArray; //Vector for the filter matrix numbers
input reset; //to proccess a new input pixel
output reg [(DATAWIDTH-1):0] convOut; //The output of the conv layer 

//intermediate parameters
reg [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] mulResult;
reg [(DATAWIDTH*ROWSIZE-1):0] previousRowSum;
reg [(DATAWIDTH*LAST_ADDITION-1):0] lastRowSum;

//The parameters for the adder & multiplier objects

wire [(DATAWIDTH-1):0]addOutput1;
reg [(DATAWIDTH-1):0]InputA1;
reg [(DATAWIDTH-1):0]InputB1;
wire [(DATAWIDTH-1):0]MulOutput1;
////////////////////////////////////////

wire [(DATAWIDTH-1):0]addOutput2;
reg [(DATAWIDTH-1):0]InputA2;
reg [(DATAWIDTH-1):0]InputB2;
wire [(DATAWIDTH-1):0]MulOutput2;
////////////////////////////////////////////

wire [(DATAWIDTH-1):0]addOutput3;
reg [(DATAWIDTH-1):0]InputA3;
reg [(DATAWIDTH-1):0]InputB3;
wire [(DATAWIDTH-1):0]MulOutput3;
////////////////////////////////////////////

wire [(DATAWIDTH-1):0]addOutput4;
reg [(DATAWIDTH-1):0]InputA4;
reg [(DATAWIDTH-1):0]InputB4;
wire [(DATAWIDTH-1):0]MulOutput4;
////////////////////////////////////////////

wire [(DATAWIDTH-1):0]addOutput5;
reg [(DATAWIDTH-1):0]InputA5;
reg [(DATAWIDTH-1):0]InputB5;
wire [(DATAWIDTH-1):0]MulOutput5;
////////////////////////////////////////////

//initalizing counters
reg [5:0] i =0;
reg [5:0] j =0;
reg [5:0] k =0;
reg [5:0] z=0;
reg [5:0] x=0;
//instaniating adder and multiplier (5 components of each module)
Fp_Add convAdder1(
 InputA1, 
 InputB1,
 addOutput1);

Fp_Mul convMul1(
 InputA1, 
 InputB1,    
 MulOutput1  
);
/////////////////////////////////////////////

Fp_Add convAdder2(
 InputA2, 
 InputB2,
 addOutput2);

Fp_Mul convMul2(
 InputA2, 
 InputB2,    
 MulOutput2  
);
///////////////////////////////////////////
Fp_Add convAdder3(
 InputA3, 
 InputB3,
 addOutput3);

Fp_Mul convMul3(
 InputA3, 
 InputB3,    
 MulOutput3  
);
/////////////////////////////////////////////////
Fp_Add convAdder4(
 InputA4, 
 InputB4,
 addOutput4);

Fp_Mul convMul4(
 InputA4, 
 InputB4,    
 MulOutput4  
);
/////////////////////////////////////////////////
Fp_Add convAdder5(
 InputA5, 
 InputB5,
 addOutput5);

Fp_Mul convMul5(
 InputA5, 
 InputB5,    
 MulOutput5  
);
////////////////////////////////////////////////////
//code sequence depends on 2 always@ blocks one for +ve edge and the other for -ve edge
//using 5 multipliers and 5 adders in order to achieve some kind of parallelism without adding too much luts
//first passing 5 elements by every clk cycle to the multipliers 
//then store the multiplication result in the parameter [mulResult]
//note: passing parameters in +ve edge , getting the ressult in the -ve edge
//then performing adding [mulResult] row + row 
//store the final row result in a parameter [previousRowSum]
//then performing addition on the [previousRowSum] which contains 5 numbers 
//picking first 4 and adding them using 2 adders and store the result in [lastRowSum]
//then adding 2 elements stored in [lastRowSum] 
//finally adding the result of the previous operation to the element number 5 in the [previousRowSum]
///////////////////////////////////////////////////////////////////////////////////

always@(posedge clk)
begin
    if(reset ==1)
    begin
        i =0;
        j=0;
        k=0;
    end
    else if(i < 25)  //performing element wise multiplication by passing elements to the 5 adders in parallel 
                //needs 5 clk cycles (5*5 elements and each clk cycle only multiply 1*1 -> 5 times)
    begin
        InputA1 <= imageArray[i*DATAWIDTH+:DATAWIDTH];
        InputB1 <= filterArray[i*DATAWIDTH+:DATAWIDTH];
        
        InputA2 <= imageArray[(i+1)*DATAWIDTH+:DATAWIDTH];
        InputB2 <= filterArray[(i+1)*DATAWIDTH+:DATAWIDTH];
        
        InputA3 <= imageArray[(i+2)*DATAWIDTH+:DATAWIDTH];
        InputB3 <= filterArray[(i+2)*DATAWIDTH+:DATAWIDTH];
        
        InputA4 <= imageArray[(i+3)*DATAWIDTH+:DATAWIDTH];
        InputB4 <= filterArray[(i+3)*DATAWIDTH+:DATAWIDTH];
        
        InputA5 <= imageArray[(i+4)*DATAWIDTH+:DATAWIDTH];
        InputB5 <= filterArray[(i+4)*DATAWIDTH+:DATAWIDTH];
      
        i= i+5;
    end
    else if(i <27) //after finishing multiplication now [mulResult] is 5*5 matrix of results
                   //when i==27 -> adding forst 2 rows 
    begin
         InputA1 <= mulResult[k*DATAWIDTH+:DATAWIDTH];
         InputB1 <= mulResult[(k+5)*DATAWIDTH+:DATAWIDTH];
         
         InputA2 <= mulResult[(k+1)*DATAWIDTH+:DATAWIDTH];
         InputB2 <= mulResult[(k+6)*DATAWIDTH+:DATAWIDTH];
         
         InputA3 <= mulResult[(k+2)*DATAWIDTH+:DATAWIDTH];
         InputB3 <= mulResult[(k+7)*DATAWIDTH+:DATAWIDTH];
        
         InputA4 <= mulResult[(k+3)*DATAWIDTH+:DATAWIDTH];
         InputB4 <= mulResult[(k+8)*DATAWIDTH+:DATAWIDTH];

         InputA5 <= mulResult[(k+4)*DATAWIDTH+:DATAWIDTH];
         InputB5 <= mulResult[(k+9)*DATAWIDTH+:DATAWIDTH];
         k=k+10;
         i= i+1;
    end

    else if(i>=27 && i <33) //if i>=27 starting accumelation procces in reg[previousRowSum]
                            //by adding its result to a new row of result 5*5  matrix
    begin
         InputA1 <= mulResult[k*DATAWIDTH+:DATAWIDTH];
         InputB1 <= previousRowSum[z*DATAWIDTH+:DATAWIDTH];
         
         InputA2 <= mulResult[(k+1)*DATAWIDTH+:DATAWIDTH];
         InputB2 <= previousRowSum[(z+1)*DATAWIDTH+:DATAWIDTH];
         
         InputA3 <= mulResult[(k+2)*DATAWIDTH+:DATAWIDTH];
         InputB3 <= previousRowSum[(z+2)*DATAWIDTH+:DATAWIDTH];
        
         InputA4 <= mulResult[(k+3)*DATAWIDTH+:DATAWIDTH];
         InputB4 <= previousRowSum[(z+3)*DATAWIDTH+:DATAWIDTH];

         InputA5 <= mulResult[(k+4)*DATAWIDTH+:DATAWIDTH];
         InputB5 <= previousRowSum[(z+4)*DATAWIDTH+:DATAWIDTH];
         k=k+5;
         i= i+1;
    end
    
    else if(i==33) //i == 33 -> now accumealting the rows in [previousRowSum] is finished 
                   //start adding the 5 elements of [previousRowSum] t each other in 3 stages (3 clk cycles)
                   //1 ->> previousRowSum[0] + previousRowSum[1] && previousRowSum[2] + previousRowSum[3]
    begin
         InputA1 <= previousRowSum[z*DATAWIDTH+:DATAWIDTH];
         InputB1 <= previousRowSum[(z+1)*DATAWIDTH+:DATAWIDTH];
         
         InputA2 <= previousRowSum[(z+2)*DATAWIDTH+:DATAWIDTH];
         InputB2 <= previousRowSum[(z+3)*DATAWIDTH+:DATAWIDTH];

         i= i+1;
    end
    
    else if(i==34)//2 ->> RESULT(previousRowSum[0] + previousRowSum[1]) + RESULT(previousRowSum[2] + previousRowSum[3])
    begin
         InputA1<=lastRowSum[x*DATAWIDTH+:DATAWIDTH];
         InputB1<=lastRowSum[(x+1)*DATAWIDTH+:DATAWIDTH];
         i= i+1;
    end
    else if (i == 35 )//3 ->> last stage : previousRowSum[4] + RESULT OF STAGE 2
    begin
        InputA1 <= lastRowSum[x*DATAWIDTH+:DATAWIDTH];
        InputB1 <= previousRowSum[(z+4)*DATAWIDTH+:DATAWIDTH];
         i= i+1;
    end

end
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////GETTING RESULTS OF THE PREVIOUS OPERATIONS//////////////////////////////////////////

always@(negedge clk)
begin
    if(i < 26 && i!=0)  //performing element wise multiplication by passing elements to the 5 adders in parallel 
               //needs 5 clk cycles (5*5 elements and each clk cycle only multiply 1*1 -> 5 times)
    begin
            mulResult[j*DATAWIDTH+:DATAWIDTH] <= MulOutput1 ;
            mulResult[(j+1)*DATAWIDTH+:DATAWIDTH] <= MulOutput2;
            mulResult[(j+2)*DATAWIDTH+:DATAWIDTH] <= MulOutput3;
            mulResult[(j+3)*DATAWIDTH+:DATAWIDTH] <= MulOutput4;
            mulResult[(j+4)*DATAWIDTH+:DATAWIDTH] <= MulOutput5;
            j= j+5;
    end
    //adding first 2 rows && ACCUMELATION PROCCES 
    else if(i >= 26 && i < 33)
    begin
        previousRowSum[z*DATAWIDTH+:DATAWIDTH] <= addOutput1;
        previousRowSum[(z+1)*DATAWIDTH+:DATAWIDTH] <= addOutput2;
        previousRowSum[(z+2)*DATAWIDTH+:DATAWIDTH] <= addOutput3;
        previousRowSum[(z+3)*DATAWIDTH+:DATAWIDTH] <= addOutput4;
        previousRowSum[(z+4)*DATAWIDTH+:DATAWIDTH] <= addOutput5;
        i=i+1;
    end

    else if(i == 34) //LAST 3 STAGES OF ADDING
                    //#1
    begin
        lastRowSum[x*DATAWIDTH+:DATAWIDTH] <= addOutput1;  
        lastRowSum[(x+1)*DATAWIDTH+:DATAWIDTH] <= addOutput2;   
    end
    
    else if(i == 35) //#2
    begin
        lastRowSum[x*DATAWIDTH+:DATAWIDTH] <= addOutput1;    
    end
    else //#3 ASSIGNING THE FINAL VALUE TO THE OUTPUT 
    begin
       convOut <= addOutput1;
    end
    
end



endmodule