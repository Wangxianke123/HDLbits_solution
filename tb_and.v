//https://hdlbits.01xz.net/wiki/Tb/and


module top_module();
    reg in1; reg in2;
    wire out;
    
    andgate gate(.in({in1,in2}),.out(out));
    initial begin
    in1 = 0; in2 = 0;
    #10 
    in1 = 0;in2 = 1;
    #10 
    in1 = 1;in2 = 0;
    #10 
    in1 = 1;in2 = 1;
    end
endmodule
