//https://hdlbits.01xz.net/wiki/Tb/tff

module top_module ();
	
    reg clk;
    reg reset;
    reg t;
    wire q;

    tff tff0 (
        .clk(clk),
        .reset(reset),
        .t(t),
        .q(q)
    );

    initial begin
        clk = 0;
    end

    always #5 clk = ~clk;

    initial begin
        reset = 0;
        #10 reset = 1;
        #10 reset= 0; t =1;
        #10 t = 0;
    end
endmodule
