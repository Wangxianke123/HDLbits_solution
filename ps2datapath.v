//https://hdlbits.01xz.net/wiki/Fsm_ps2data

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    // FSM from fsm_ps2
    parameter BYTE1 = 2'b00, BYTE2 = 2'b01, BYTE3 = 2'b10, DONE = 2'b11;
    wire [1:0]next_state;
    reg [1:0]state;
    reg [23:0] byte_store;
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

    always @(posedge clk ) begin
        if(reset)
            byte_store <= 16'b0;
        else if(in[3])begin
            case (state)
                BYTE1:byte_store[23:16] <= in;
                BYTE2:byte_store[15:8] <= in;
                BYTE3:byte_store[7:0] <= in;
                DONE:byte_store[23:16] <= in;  
            endcase
        end
        else begin
            case (state)
                BYTE1:byte_store <= byte_store;
                BYTE2:byte_store[15:8] <= in;
                BYTE3:byte_store[7:0] <= in;
                DONE:byte_store <= byte_store; 
            endcase
        end
    end

    // Output logic
    assign done=(state == DONE);
    // New: Datapath to store incoming bytes.
    assign out_bytes = byte_store;

endmodule
