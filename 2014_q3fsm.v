//https://hdlbits.01xz.net/wiki/Exams/2014_q3fsm

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

    parameter A = 2'b01, B = 2'b10;

    reg [1:0] state;
    reg  [1:0] next_state;
    reg [1:0] mem;   
    reg [1:0] counter;

    always @(*) begin
        case (state)
            A: next_state = (s)? B:A;
            B: next_state = B; 
			default:state=A;
        endcase
    end

    always @(posedge clk ) begin
        if(reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(posedge clk ) begin
        if(reset)
            mem <= 2'd0;
        else if(counter==2'd0)
            	mem <= w? 2'd1:2'd0;
        else if (state==B)
                mem <= w? (mem+1'b1):mem; 
    end

    always @(posedge clk ) begin
        if(reset)
            counter <= 2'd0;
        else if(counter==2'd2 )
            counter <= 2'd0;
        else if(state == B)
            counter <= counter + 1'b1;
    end

    assign z = (state==B && counter ==2'd0 && mem == 2'd2); 

endmodule
