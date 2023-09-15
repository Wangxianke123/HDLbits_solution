//https://hdlbits.01xz.net/wiki/Fsm_serialdp

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

   parameter READY = 4'b0000, ONE = 4'b0001, TWO = 4'b0010,THREE = 4'd3,
    FOUR = 4'd4,FIVE = 4'd5, SIX = 4'd6, SEVEN = 4'd7, EIGHT = 4'd8, NINE = 4'd9, DONE = 4'd10,
    WAIT = 4'd11, PARITY = 4'd12;

    reg [3:0] next_state;
    reg [3:0]state;
    
    reg[7:0] byte_store;

    wire odd;
    wire parity_reset;



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
            EIGHT: next_state = PARITY;
            PARITY: next_state = (odd)?NINE:WAIT;
            NINE: next_state = (in)? DONE:WAIT;
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


    always @(posedge clk ) begin
        if(reset)
            byte_store <= 8'b0;
        else
            case (state)
                READY: byte_store <= byte_store;
                ONE: byte_store <= {in,byte_store[7:1]};
                TWO: byte_store <= {in,byte_store[7:1]};
                THREE:byte_store <= {in,byte_store[7:1]};
                FOUR: byte_store <= {in,byte_store[7:1]};
                FIVE: byte_store <= {in,byte_store[7:1]};
                SIX: byte_store <= {in,byte_store[7:1]};
                SEVEN: byte_store <= {in,byte_store[7:1]};
                EIGHT: byte_store <= {in,byte_store[7:1]};
                PARITY: byte_store <= byte_store;
                NINE: byte_store <= byte_store;
                DONE: byte_store <= byte_store;
                WAIT: byte_store <= byte_store;
            endcase
    end
    
    assign out_byte = byte_store;

    assign parity_reset = (state==DONE) | (state==READY) | (state ==WAIT);

    parity parity0(
    .clk(clk),
    .reset(parity_reset),
    .in(in),
    .odd(odd)
    );
endmodule

