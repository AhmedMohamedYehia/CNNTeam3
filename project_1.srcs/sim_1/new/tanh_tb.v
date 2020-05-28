
module tanh_tb;
    reg[31:0] x;
    reg clk;
    wire[31:0]tanhx;


    
    initial
    begin
    #0 x = 32'b01000000010000000000000000000000;
    clk=0;
    #600 $stop;
    end
    
    always
    begin 
    #20 clk =~clk;
    end
    
    
     
 
    
 tanh tanhModule ( //instantiate the module
    .x(x),
    .clk(clk),
    .tanhx(tanhx)
 );
endmodule
