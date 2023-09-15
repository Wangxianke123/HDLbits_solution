//https://hdlbits.01xz.net/wiki/Exams/m2014_q6c

module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);

    assign Y2= y[1]& ~w;
    assign Y4 = w&y[2] | w&y[3] | w&y[5] | w&y[6];
endmodule
