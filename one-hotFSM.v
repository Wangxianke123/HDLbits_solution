module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);


    always @(*) begin
        if(in)begin
            next_state = {2'b00,state[7]|state[6],state[5:1],state[8]|state[9]|state[0],1'b0};
        end
        else begin
            next_state = {state[6:5],7'b0,(|state[4:0])|(|state[9:7])};
        end
    end

    assign out1 = state[8]|state[9];
    assign out2 = state[9]|state[7];
endmodule

