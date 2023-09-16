//https://hdlbits.01xz.net/wiki/Exams/review2015_fancytimer

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );


    parameter INIT = 4'd0,A = 4'd1,B=4'd2,C=4'd3,D=4'd4,E=4'd5,F=4'd6,G=4'd7,H=4'd8,I=4'd9;

    reg[3:0] state;
    reg[3:0] next_state;

    reg[14:0] counter;

    reg[3:0] shifter;
    wire shift_ena;
    wire done_counting;
    reg [9:0] counter1k;

    wire decay;



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


    always @(posedge clk) begin
        if(reset)
            counter1k <= 10'd0;
        else if(counter1k==10'd999)
            counter1k <= 10'd0;
        else if(counting)
            counter1k <= counter1k + 1'b1;
    end

    assign decay = (counter1k == 10'd999);
    
    always @(posedge clk ) begin
        if(reset)
            shifter <= 4'd0;
        else if(shift_ena)
            shifter <= {shifter[2:0],data};
        else if(decay)
            shifter <= shifter - 1'b1;
    end
	
 

    assign count = shifter;
    
    always @(posedge clk ) begin
        if(reset)
            counter <= 15'd0;
        else if(state==G)
            counter <= ({shifter[2:0],data} + 1'b1) * 10'd1000;
        else if(counting)
            counter <= counter - 1'b1;
    end

    assign done_counting = (counter == 15'd1);
endmodule
