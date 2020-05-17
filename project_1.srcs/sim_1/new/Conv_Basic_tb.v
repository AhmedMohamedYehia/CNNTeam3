`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2020 00:05:59
// Design Name: 
// Module Name: Conv_Basic_tb
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


module Conv_Basic_tb();
reg clk;
reg [287:0] imageArray;
reg [287:0]filterArray;
wire [31:0] convOut;

initial begin 
clk =0;
assign imageArray=287'b001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000;
assign filterArray=287'b001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000001111111000000000000000000000000011111110000000000000000000000000111111100000000000000000000000;
end

always
begin 

#5 clk =~clk;
end

Conv_Basic convBasic1(
clk,//The clock for the system
imageArray, //Vector for the image matrix numbers
filterArray, //Vector for the filter matrix numbers
convOut //The output of the conv layer 
);
endmodule
