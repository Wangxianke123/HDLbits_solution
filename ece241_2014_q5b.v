//https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q5b

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter NOONE = 2'b01, ONE = 2'b10;

    reg [1:0]state;
    reg [1:0]next_state;


    always @(*) begin
        if(state == NOONE)begin
            next_state = (x)? ONE:NOONE;
        end
        else begin
            next_state = ONE;
        end
    end

    always @(posedge clk ,posedge areset) begin
        if(areset)
            state <= NOONE;
        else
            state <= next_state;
    end

    assign z = (state == ONE)? ~x:x;
endmodule
