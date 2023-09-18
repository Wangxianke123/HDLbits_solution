//https://hdlbits.01xz.net/wiki/Cs450/counter_2bc

module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    parameter SNT = 2'b00,WNT = 2'b01,WT = 2'b10,ST = 2'b11 ;
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            SNT: next_state = train_valid? (train_taken?WNT:SNT):SNT;
            WNT: next_state = train_valid? (train_taken?WT:SNT):WNT;
            WT:  next_state = train_valid? (train_taken?ST:WNT):WT;
            ST:  next_state = train_valid? (train_taken?ST:WT):ST;
        endcase
    end

    always @(posedge clk ,posedge areset) begin
        if(areset)
            state <= WNT;
        else
            state <= next_state;
    end

endmodule
