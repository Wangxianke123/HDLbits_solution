//https://hdlbits.01xz.net/wiki/Exams/review2015_fsmseq

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);


    parameter INIT = 3'b000, A=3'b001,B=3'b010,C=3'b011,D=3'b101;

    reg[2:0] state;
    reg[2:0] next_state;

    always @(*) begin
        case (state)
            INIT:next_state = data? A:INIT; 
            A:  next_state = data? B:INIT;
            B:  next_state = data? B:C;
            C:  next_state = data? D:INIT;
            D:  next_state = D;
            default: next_state = INIT;
        endcase
    end

    always @(posedge clk ) begin
        if(reset)
            state <= INIT;
        else
            state <= next_state;
    end

    assign start_shifting=(state==D);
endmodule
