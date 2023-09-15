//https://hdlbits.01xz.net/wiki/Fsm_serial
//https://hdlbits.01xz.net/wiki/Fsm_serial
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    parameter READY = 4'b0000, ONE = 4'b0001, TWO = 4'b0010,THREE = 4'd3,
    FOUR = 4'd4,FIVE = 4'd5, SIX = 4'd6, SEVEN = 4'd7, EIGHT = 4'd8,NINE = 4'd9, DONE = 4'd10,
    WAIT = 4'd11;

    wire [3:0] next_state;
    reg [3:0]state;
    
    always @(*) begin
        case (state)
            READY: next_state = (in)?READY:ONE;
            ONE: next_state = TWO;
            TWO: next_state = THREE;
            THREE:next_state = FOUR;
            FOUR: next_state = FIVE;
            FIVE: next_state = SIX;
            SIX: next_state = SEVEN;
            SEVEN: next_state = EIGHT;
            EIGHT: next_state = NINE;
            NINE: next_state = (in)?DONE:WAIT;
            DONE: next_state = (in)?READY:ONE;
            WAIT: next_state = (in)?READY:WAIT;
        endcase
    end

    always @(posedge clk) begin
        if(reset)
            state <= READY;
        else
            state <= next_state;
    end

    assign done = (state == DONE);
endmodule
