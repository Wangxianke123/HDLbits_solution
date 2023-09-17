//https://hdlbits.01xz.net/wiki/Tb/clock

module top_module ( );
	reg clk;
    initial clk = 0;
    always #5 clk = ~clk;
    dut dut0(.clk(clk));
endmodule
