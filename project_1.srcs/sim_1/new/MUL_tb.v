
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 12:15:58 AM
// Design Name: 
// Module Name: FPMU_tb
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

/*`timescale 1ns / 1ps
module FPMU1_tb();
reg [31:0]FP1;
reg [31:0]FP2;
wire sign;
wire [7:0] exp;
wire [22:0]mantessa;

initial
begin


//1.3 X 5.9 = 7.67
 FP1=32'b01000000101000000000000000000000;
 FP2=32'b01000000010000000000000000000000;

//#10 FP1=32'b00111111101100110011001100110011;
//#10 FP2=32'b01000000010011001100110011001101;
end

FPMU1 test(
    FP1,
    FP2,
    sign,
    exp,
    mantessa
);
    
    
endmodule*/

 //test bench for floating-point multiplication
`timescale 1ns / 1ps
module FPMU1_tb();
reg [15:0] flp_a;
reg [15:0]flp_b;
wire [15:0]f1p_product;
//display variables

initial
begin


//Result is (0100010010001101)
flp_a =16'b0100001100000000;
flp_b =16'b0011110100110011;

/*
//Result is (00111100010110110000001011000110)
flp_a =32'b01000000011000000000000000000000;
flp_b =32'b00111011011110100100110001010000;


 #5 flp_a =32'b00111111111100110011001100110011;//1.9
 flp_b =32'b01000000001100110011001100110011;//2.8
// the expected result 5.32 :0 10000001 01010100011110101110000

#5 flp_a =32'b01000000001000000000000000000000;//2.5
flp_b =32'b00111111100110011001100110011010;//1.2
//// the expected result 3 :0 10000000 10000000000000000000000

 #5 flp_a =32'b01000000010011001100110011001101;//3.2
flp_b =32'b00111111100110011001100110011010;//1.2
//// the expected result 3.84 :0 10000000 11101011100001010001111


*/

end
//instantiate the module into the test bench
Fp_Mul inst1 (
flp_a,
flp_b,
f1p_product
);
endmodule
