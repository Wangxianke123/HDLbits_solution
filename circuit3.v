//https://hdlbits.01xz.net/wiki/Sim/circuit3

module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = b&c|b&c|a&c|a&d|b&d; // Fix me

endmodule
