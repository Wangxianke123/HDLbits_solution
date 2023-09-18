//https://hdlbits.01xz.net/wiki/Cs450/timer

module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);
    reg[9:0] counter;

    always @(posedge clk ) begin
        if(load)
            counter <= data;
        else if(counter == 0)
            counter <= counter;
        else
            counter <= counter - 1'b1;
        
    end

    assign tc = counter==10'd0;
endmodule
