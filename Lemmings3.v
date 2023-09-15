module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 


    parameter L =3'b000,R=3'b001,FL = 3'b010,FR=3'b011,DL = 3'b100,DR = 3'b101 ;

    wire [2:0]next_state;
    reg  [2:0]state;

    always @(*) begin
        if(ground)begin
            case (state)
                L: next_state = (dig)? DL : (bump_left)?R:L;
                R: next_state = (dig)? DR : (bump_right)? L:R;
                DL:next_state = DL;
                DR:next_state = DR;
                FL:next_state = L;
                FR:next_state = R;
            endcase
        end    
        else begin
            case (state)
                L:next_state = FL;
                R:next_state = FR;
                DL:next_state = FL;
                DR:next_state = FR;
                FL:next_state = FL;
                FR:next_state = FR;
            endcase
        end
    end

    always @(posedge clk ,posedge areset) begin
        if(areset)
            state <= L;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            L:begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end 
            R:begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end 
            DL:begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end 
            DR:begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end 
            FL:begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end 
            FR:begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end 
        endcase
    end
endmodule
