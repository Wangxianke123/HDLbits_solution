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


    parameter L = 3'b000,R = 3'b001,DL = 3'b010,DR = 3'b011,FL = 3'b100,FR = 3'b101,LF = 3'b110,DIE = 3'b111;

    wire [2:0]next_state;
    reg  [2:0]state;
    reg long_time;
    reg [4:0] time_counter;
    always @(*) begin
        if(ground)begin
            case(state)
            L:next_state = (dig)? DL : (bump_left)? R: L;
            R:next_state = (dig)? DR : (bump_right)? L:R;
            DL: next_state = DL;
            DR: next_state = DR;
            FL: next_state = (long_time)? DIE:L;
            FR: next_state = (long_time)? DIE:R;
            DIE: next_state = DIE;
            endcase
        end
        else begin
            case (state)
            L:next_state = FL;
            R:next_state = FR;
            DL: next_state = FL;
            DR: next_state = FR;
            FL: next_state = FL;
            FR: next_state = FR;
            DIE: next_state = DIE; 
            endcase
        end
    end

    always @(posedge clk ,posedge areset) begin
        if(areset)begin
            long_time <= 0;
            time_counter <= 0;
            state <= L;
        end
        else begin
            state <= next_state;
            if(aaah)
                time_counter <= time_counter + 1'b1;
            else
                time_counter <= 0;
            if (time_counter >= 5'd19)
                long_time <= 1;
        end
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
            DL: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            DR: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            FL: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            FR: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIE: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end
endmodule
