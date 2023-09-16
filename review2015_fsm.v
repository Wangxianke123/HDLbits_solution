//https://hdlbits.01xz.net/wiki/Exams/review2015_fsm
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );

    parameter INIT = 4'd0,A = 4'd1,B=4'd2,C=4'd3,D=4'd4,E=4'd5,F=4'd6,G=4'd7,H=4'd8,I=4'd9;

    reg[3:0] state;
    reg[3:0] next_state;

    always @(*) begin
        case (state)
            INIT:next_state = data? A:INIT; 
            A:  next_state = data? B:INIT;
            B:  next_state = data? B:C;
            C:  next_state = data? D:INIT;
            D:  next_state = E;
            E:  next_state = F;
            F:  next_state = G;
            G:  next_state = H;
            H:  next_state = done_counting? I:H;
            I:  next_state = ack? INIT:I;
            default: next_state = INIT;
        endcase
    end

    always @(posedge clk ) begin
        if(reset)
            state <= INIT;
        else
            state <= next_state;
    end

   assign shift_ena=(state==D||state==E||state==F||state==G);
   assign counting = (state==H);
   assign done = (state==I);

endmodule
