//https://hdlbits.01xz.net/wiki/Exams/ece241_2013_q8

module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 


    parameter INIT = 2'b00, ONE = 2'b01,TWO = 2'b11;

    reg[1:0]state;
    reg [1:0]next_state;

    always @(*) begin
        case (state)
            INIT: next_state = (x)? ONE:INIT; 
            ONE : next_state = (x)? ONE:TWO;
            TWO : next_state = (x)? ONE:INIT;
        endcase
    end

    always @(posedge clk ,negedge aresetn) begin
        if(!aresetn)
            state <= INIT;
        else
            state <= next_state;
    end

    assign z = (state==TWO) & (x==1'b1);
endmodule
