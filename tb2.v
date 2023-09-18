//https://hdlbits.01xz.net/wiki/Tb/tb2

module top_module();
	reg clk;
    reg in;
    reg [2:0]s;
    wire out;

    initial clk = 0;

    always #5 clk = ~clk;

    initial begin
        s = 3'd2;
    #10 s = 3'd6;
    #10 s = 3'd2;
    #10 s = 3'd7;
    #10 s = 3'd0;
    end

    initial begin
        in = 0;
    #20 in = 1;
    #10 in = 0;
    #10 in = 1;
    #30 in = 0;
    end

    q7 qq(
        .clk(clk),
        .in(in),
        .s(s),
        .out(out)
    );
endmodule
