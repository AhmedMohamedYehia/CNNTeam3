//////////////////////////////////////////////////////////////////////////////////
// Create Date: 30.05.2020 13:42:20
// Design Name: PART 1 - (b)
// Module Name: SingleFilter_Conv
// Project Name: CNN Final Assesment
//////////////////////////////////////////////////////////////////////////////////

//test bench will not work with theese conditions of data width.
module SingleFilter_Conv(clk,image,filter,ConvImage);

parameter DATAWIDTH =32; //data width of each number either 16 or 32
parameter NUMBEROFPIXELS = 100; //32x32 input image
parameter NUMBEROFPIXELS_OUT = 36;  //28x28 output image
parameter ROWSIZE =5;//The row size
parameter COLUMNSIZE =5;//The column size
parameter MATRIXWIDTH= 10; //32 
//parameter OUTPUTSIZE =;
input clk;
input [(DATAWIDTH*NUMBEROFPIXELS-1):0] image;  //32x32 input image
input [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] filter;  //5x5 filter 
output reg [(DATAWIDTH*NUMBEROFPIXELS_OUT-1):0]ConvImage; //28x28 output image
////////////////////////////////////////////////////////////////////////////////////

//The parameters for the Conv_Basic objects
reg [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] imageArray1;
reg [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] filterArray;
wire [(DATAWIDTH-1):0] convOut1;

reg [(DATAWIDTH*ROWSIZE*COLUMNSIZE-1):0] imageArray2;
wire [(DATAWIDTH-1):0] convOut2;
////////////////////////////////////////////////////////////////////////////////////  
reg reset; 
Conv_Basic BasicUnit1(
clk,
imageArray1,
filterArray,
convOut1,
reset
);
Conv_Basic BasicUnit2(
clk,
imageArray2,
filterArray,
convOut2,
reset
);
//

reg [15:0] max = (DATAWIDTH*NUMBEROFPIXELS-1); //MSB "start"
reg [15:0] j = (DATAWIDTH*NUMBEROFPIXELS_OUT-1);   //output index
reg [13:0] k =0;   //+ve edge clk counter
reg [13:0] x =0;  //-ve edge clk counter
reg [15:0] skippingCounter;
/////////////////////////////////////////////////////////////////////////////
//code sequence depends on 2 always@ blocks one for +ve edge and the other for -ve edge
//passing the centered 5x5 matrix sliced from input to the [Conv_Basic] module to perform convolution
//passing parameters in the -ve edge & take the reult in the +ve edge
//using operation (k % 13) because the module [Conv_Basic] needs 13 clk cycle to perform convolution to 1 pixel (5x5 matrix)
/////////////////////////////////////////////////////////////////////////////


always@(negedge clk)
begin
    reset =0; //ressteing signal for the module [Conv_Basic] to accept a new input
    
    if(k ==0)   //[SkippingCounter] variable is a counter to determine moving to the next row or not (for input mapping)
    begin
        skippingCounter =0;
    end
    if(((k %13) == 0))  //13 is the number of cycles that [Conv_Basic] need to complete the conv process for 1 pixel only
    begin
    //constructing the centered 5x5 matrix by conactinating 5 rows of input 
    imageArray1  = {image[max -: (5*DATAWIDTH)] ,
                   image[(max-1*MATRIXWIDTH*DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-2*MATRIXWIDTH*DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-3*MATRIXWIDTH*DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-4*MATRIXWIDTH*DATAWIDTH) -: (5*DATAWIDTH)] 
                   };
    //passing the filter input to the module               
    filterArray = filter;
    
    imageArray2  = {image[max-DATAWIDTH -: (5*DATAWIDTH)] ,
                   image[(max-1*MATRIXWIDTH*DATAWIDTH-DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-2*MATRIXWIDTH*DATAWIDTH-DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-3*MATRIXWIDTH*DATAWIDTH-DATAWIDTH) -: (5*DATAWIDTH)] , 
                   image[(max-4*MATRIXWIDTH*DATAWIDTH-DATAWIDTH) -: (5*DATAWIDTH)] 
                   };
                    skippingCounter = skippingCounter+1;
    //filterArray = 800'h40400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000;
    end
    k=k+1;   //incrementing +ve edge clk counter
    if(((x %13) == 0) && k !=0)
    begin
        reset =1;              //reseting the [Conv_Basic] module to accept another input
    end
end

always@(posedge clk)
begin
    if(((x %13) == 0) && k !=0)
    begin
    //for the end of the row to ensure that the last index of the row is number 28 not 32 we must sub 4*DATAWIDTH not 2*DATAWIDTH
        if (skippingCounter == 3)
        begin
            max = max-6*DATAWIDTH;  //moving to the next row
            skippingCounter=0;
        end
        else
        begin
            max = max-2*DATAWIDTH;  //moving to the next element in the same row
        end
        //assigning the output
        ConvImage[j -:DATAWIDTH] = convOut1; 
        ConvImage[j-1*DATAWIDTH -:DATAWIDTH] = convOut2;
        //incrementing output array index
        if(x != 0)
        begin
            j=j-2*DATAWIDTH;
        end   
    end
    x=x+1;      //incrementing -ve edge clk counter
end
endmodule
