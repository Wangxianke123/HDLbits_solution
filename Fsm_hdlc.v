//https://hdlbits.01xz.net/wiki/Fsm_hdlc

module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);


    parameter ZERO = 4'd0,  ONE = 4'd1,  TWO = 4'd2, THREE = 4'd3, FOUR = 4'd4, FIVE = 4'd5,
    SIX = 4'd6, DISCARD = 4'd7, FLAG = 4'd8, ERROR = 4'd9;

    reg [3:0]state;
    reg [3:0]next_state;

    always @(*) begin
        case (state)
            ZERO:next_state = (in)?  ONE:ZERO;
            ONE: next_state = (in)? TWO:ZERO;
            TWO: next_state = (in)?THREE:ZERO;
            THREE: next_state = (in)?FOUR:ZERO;
            FOUR: next_state = (in)? FIVE:ZERO;
            FIVE: next_state = (in)?SIX:DISCARD;
            SIX: next_state = (in)?ERROR:FLAG;
            DISCARD: next_state = (in)?ONE:ZERO;
            FLAG: next_state = (in)?ONE:ZERO;
            ERROR: next_state = (in)?ERROR:ZERO;
        endcase
    end

    always @(posedge clk ) begin
        if(reset)
            state <= ZERO;
        else 
            state <= next_state;
    end

    assign disc = (state==DISCARD);
    assign flag = (state == FLAG);
    assign err = (state==ERROR);
endmodule
