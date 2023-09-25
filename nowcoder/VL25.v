//https://www.nowcoder.com/practice/d65c2204fae944d2a6d9a3b32aa37b39?tpId=302&tqId=5000628&ru=/exam/oj&qru=/ta/verilog-advanced/question-ranking&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DVerilog%25E7%25AF%2587%26topicId%3D353
//请编写一个序列检测模块，检测输入信号a是否满足01110001序列，当信号满足该序列，给出指示信号match。
`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input a,
	output reg match
	);

    reg[7:0] mem;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            mem <= 0;
            match <= 0;
		end
        else begin
            mem <= {mem[6:0],a};
            match <= (mem==8'b01110001);
		end
    end


endmodule