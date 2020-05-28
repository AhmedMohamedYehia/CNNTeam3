
module tanh_tb;
    reg[31:0] x;
    reg clk;
    reg reset;
    wire[31:0]tanhx;


    
    initial
    begin
    #0 x = 32'b01000000010000000000000000000000;    //x=3
    clk=0;
    #350 reset = 1;
    #50 reset=0;
    #10 x = 32'b01000000100000000000000000000000;    //x=4
    #350 reset = 1;
    #50 reset=0;
    #10 x = 32'b01000000101000000000000000000000;    //x=5
    /*#350 reset = 1;
    #50 reset=0;
    #10 x = 32'b01000000110000000000000000000000;    //x=6*/
    #3000 $stop;
    end
    
    always
    begin 
    #20 clk =~clk;
    end
    
    
     
 
    
 tanh tanhModule ( //instantiate the module
    .x(x),
    .clk(clk),
    .reset(reset),
    .tanhx(tanhx)
 );
endmodule
