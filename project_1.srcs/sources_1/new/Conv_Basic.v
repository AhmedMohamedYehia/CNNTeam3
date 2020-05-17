`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2020 22:01:37
// Design Name: 
// Module Name: Conv_Basic
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
//////////////////////////////////////////////////////////////////////////////


module Conv_Basic(clk,imageArray,filterArray,convOut);

parameter ROWSIZE =3;//The row size
parameter COLUMNSIZE =3;//The column size
parameter DATAWIDTH =32;
parameter DATAWIDTHEXPONENT=8;
parameter DATAWIDTHMANTISSA=23;

input clk;//The clock for the system
input [32*ROWSIZE*COLUMNSIZE:0] imageArray; //Vector for the image matrix numbers
input [32*ROWSIZE*COLUMNSIZE:0] filterArray; //Vector for the filter matrix numbers
output reg [31:0] convOut; //The output of the conv layer 

//The parameters for the adder object 
reg [31:0]addInputA;
reg [31:0]addInputB;
wire addSign;
wire  [7:0] addExponent;
wire [22:0] addMantissa;
////////////////////////////////////////
wire [32*ROWSIZE*COLUMNSIZE:0] concatenatedMulOutput;
integer j;
 Fp_Add convAdder(
 addInputA, 
 addInputB,
 addSign, 
 addExponent, 
 addMantissa);
genvar i;
 generate 
     for (i=0; i < ROWSIZE*COLUMNSIZE ; i=i+1)
     begin 
     Fp_Mul convMultiplier(
      imageArray[i*DATAWIDTH+:DATAWIDTH],
      filterArray[i*DATAWIDTH+:DATAWIDTH],
      concatenatedMulOutput[i*32+31],
      concatenatedMulOutput[i*DATAWIDTHEXPONENT+:DATAWIDTHEXPONENT],
      concatenatedMulOutput[i*DATAWIDTHMANTISSA+:DATAWIDTHMANTISSA]
      );
     end
 endgenerate
 always@(posedge clk )
 begin
  for(j =0;j<ROWSIZE*COLUMNSIZE;j=j+1)
  begin
  addInputA=concatenatedMulOutput[j*DATAWIDTH+:DATAWIDTH];
  if(j==0)
  begin
  addInputB=32'b00000000000000000000000000000000;
  end
  else
  begin
    addInputB={addSign,addExponent,addMantissa};
  end
  end 
  convOut<={addSign,addExponent,addMantissa};
 end 
endmodule
