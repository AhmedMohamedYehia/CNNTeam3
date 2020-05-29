//this module is a test bench to test [Conv_Basic] module 
//by passing 2 matrices 5*5 as inputs 
//
module Conv_Basic_tb();
reg clk;
reg [799:0] imageArray;
reg [799:0]filterArray;
wire [31:0] convOut;

initial begin 
clk =0;
//these numbers are 32 bit IEEE standard form 
//imageArray = 5555522222222222222222222
//filterArray = 9999933333333333333333333
//expected result = 345
assign imageArray=800'h40A0000040A0000040A0000040A0000040A000004000000040000000400000004000000040000000400000004000000040000000400000004000000040000000400000004000000040000000400000004000000040000000400000004000000040000000;
assign filterArray=800'h41100000411000004110000041100000411000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000404000004040000040400000;
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
