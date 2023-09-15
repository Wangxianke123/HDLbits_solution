//https://hdlbits.01xz.net/wiki/Exams/2013_q2bfsm

module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 

    parameter A = 4'b0000, B = 4'b0001, C=4'b0010,D=4'b0011,
    E = 4'b0100, F = 4'b0101,G=4'b0110,H=4'b0111,I = 4'b1000;


    reg [3:0]state;
    reg [3:0]next_state;

    always @(*) begin
        case (state)
            A:next_state = B; 
            B:next_state = I;
            C:next_state = x?C:D;
            D:next_state = x?E:I;
            I:next_state = x?C:I;
            E:next_state = y?G:F;
            F:next_state = y?G:H;
            G:next_state = G;
            H: next_state = H;
            default:next_state = A;
        endcase
    end

    always @(posedge clk ) begin
        if(!resetn)
            state <= A;
        else
            state <= next_state;
    end

    assign f=(state==B);
    assign g = (state==E || state==F || state ==G);
endmodule
