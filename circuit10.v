//https://hdlbits.01xz.net/wiki/Sim/circuit10

module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );

    assign q = a ^ b ^ state;
    
    always @(posedge clk) begin
        if(a & b) begin
            state <= 1'b1;
        end
        else if(~a & ~b) begin
            state <= 1'b0;
        end
        else begin
            state <= state;
        end
    end
    
endmodule
