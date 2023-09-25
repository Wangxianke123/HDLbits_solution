//https://www.nowcoder.com/practice/cba67d06d6834a5d9b93e1087b56c8d8?tpId=302&tags=&title=&difficulty=0&judgeStatus=0&rp=0&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DVerilog%25E7%25AF%2587%26topicId%3D353
//请编写一个序列检测模块，检测输入信号a是否满足011XXX110序列（长度为9位数据，前三位是011，后三位是110，中间三位不做要求），当信号满足该序列，给出指示信号match。

`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input a,
	output reg match
	);

    reg[8:0] mem;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            mem <= 0;
            match <= 0;
        end
        else begin
            mem <= {mem[7:0],a};
            match <= (mem[8:6]==3'b011 && mem[2:0]==3'b110);
        end
    end


endmodule