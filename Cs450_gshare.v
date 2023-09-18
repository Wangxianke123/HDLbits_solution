//https://hdlbits.01xz.net/wiki/Cs450/gshare


module top_module(
    input clk,
    input areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    parameter SNT = 2'b00,WNT = 2'b01,WT = 2'b10,ST = 2'b11 ;
    reg [1:0] pht [127:0];
    

    always @(posedge clk ,posedge areset) begin
        if(areset)
            predict_history <= 0;
        else if(train_mispredicted&train_valid)
            predict_history <= {train_history[5:0],train_taken};
        else if(predict_valid)
            predict_history <= {predict_history[5:0],predict_taken}; 
    end

    wire[1:0] train_state;
    assign    train_state = pht[train_pc^train_history];
    

    assign predict_taken = pht[predict_pc ^ predict_history][1];


    always @(posedge clk ,posedge areset) begin
        if(areset)begin
            integer i;
            for(i = 0;i<128;i=i+1)
                pht[i] <= 2'b01;
        end
        else if(train_valid )begin
            case (train_state)
                SNT: pht[train_pc^train_history] <=  train_taken?WNT:SNT;
                WNT: pht[train_pc^train_history] <=  train_taken?WT:SNT;
                WT:  pht[train_pc^train_history] <=  train_taken?ST:WNT;
                ST:  pht[train_pc^train_history] <=  train_taken?ST:WT;
            endcase
        end
    end
endmodule
