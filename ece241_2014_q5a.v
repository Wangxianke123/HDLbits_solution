//https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q5a

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter INIT = 3'd0, ZERO = 3'd1, ONE = 3'd2, TWO = 3'd3, THREE = 3'd4;

    reg [2:0]state;
    reg [2:0]next_state;

    always @(*) begin
        case (state)
                INIT:next_state = (x)?ONE:ZERO;
                ZERO:next_state = (x)?ONE:ZERO;
                ONE: next_state = (x)?THREE:TWO;
                TWO: next_state = (x)?THREE:TWO;
                THREE: next_state = (x)?THREE:TWO;
        endcase
    end

    always @(posedge clk ,posedge areset) begin
        if(areset)
            state <= INIT;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            INIT:z = 0;
            ZERO:z = 1'b0;
            ONE: z = 1'b1;
            TWO: z = 1'b1;
            THREE: z = 1'b0;
        endcase
    end
    
endmodule
