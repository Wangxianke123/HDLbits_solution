//https://hdlbits.01xz.net/wiki/Fsm_ps2

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    parameter BYTE1 = 2'b00, BYTE2 = 2'b01, BYTE3 = 2'b10, DONE = 2'b11;
    wire [1:0]next_state;
    reg [1:0]state;
    // State transition logic (combinational)
    always @(*) begin
        if(in[3])begin
            case (state)
                BYTE1:next_state = BYTE2;
                BYTE2:next_state = BYTE3;
                BYTE3:next_state = DONE;
                DONE:next_state = BYTE2; 
            endcase
        end
        else begin
            case (state)
                BYTE1:next_state = BYTE1;
                BYTE2:next_state = BYTE3;
                BYTE3:next_state = DONE;
                DONE:next_state = BYTE1; 
            endcase
        end
    end
    // State flip-flops (sequential)
 
    always @(posedge clk ) begin
        if(reset)
            state <= BYTE1;
        else
            state <= next_state;
    end

    // Output logic
    assign done=(state == DONE);
endmodule
