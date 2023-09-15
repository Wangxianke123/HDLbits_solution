
module machine(
    input clk,
    input load,
    input data,
    input [3:0] neighbors,
    output reg state
);
    always @(posedge clk)begin
        if(load)
            state <= data;
        else begin
            case (neighbors)
                4'd2:
                    state <= state;
                4'd3:
                    state <= 1;
                default: 
                    state <= 0;
            endcase
        end
    end
endmodule


module cellar (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q 
); 
    wire [255:0] west;
    wire [255:0] east;
    wire [255:0] north;
    wire [255:0] south;
    wire [255:0] northwest;
    wire [255:0] northeast;
    wire [255:0] southeast;
    wire [255:0] southwest;

    assign west = { q[240],q[255:241],q[224],q[239:225],  q[208],q[223:209],  q[192], q[207:193],
                    q[176],q[191:177],q[160],q[175:161],q[144],q[159:145],q[128], q[143:129],
                    q[112],q[127:113],q[96], q[111:97], q[80], q[95:81],  q[64],  q[79:65],
                    q[48], q[63:49],  q[32], q[47:33],  q[16], q[31:17],  q[0],   q[15:1]};    

    assign east = {
    q[254:240],q[255],
    q[238:224],q[239],
    q[222:208],q[223],
    q[206:192],q[207],
    q[190:176],q[191],
    q[174:160],q[175],
    q[158:144],q[159],
    q[142:128],q[143],
    q[126:112],q[127],
    q[110:96],q[111],
    q[94:80],q[95],
    q[78:64],q[79],
    q[62:48],q[63],
    q[46:32],q[47],
    q[30:16],q[31],
    q[14:0],q[15]};  

    assign north = {
        q[15:0],q[255:16]};  

    assign south = {
        q[239:0],
        q[255:240]}; 

    assign northwest = {
        q[0],q[15:1],
        q[240],q[255:241],
        q[224],q[239:225],
        q[208],q[223:209],
        q[192],q[207:193],
        q[176],q[191:177],
        q[160],q[175:161],
        q[144],q[159:145],
        q[128],q[143:129],
        q[112],q[127:113],
        q[96],q[111:97],
        q[80],q[95:81],
        q[64],q[79:65],
        q[48],q[63:49],
        q[32],q[47:33],
        q[16],q[31:17]};  

    assign northeast = {
    q[14:0],q[15],
    q[254:240],q[255],
    q[238:224],q[239],
    q[222:208],q[223],
    q[206:192],q[207],
    q[190:176],q[191],
    q[174:160],q[175],
    q[158:144],q[159],
    q[142:128],q[143],
    q[126:112],q[127],
    q[110:96],q[111],
    q[94:80],q[95],
    q[78:64],q[79],
    q[62:48],q[63],
    q[46:32],q[47],
    q[30:16],q[31]};  

    assign southwest = {
    q[224],q[239:225],
    q[208],q[223:209],
    q[192],q[207:193],
    q[176],q[191:177],
    q[160],q[175:161],
    q[144],q[159:145],
    q[128],q[143:129],
    q[112],q[127:113],
    q[96],q[111:97],
    q[80],q[95:81],
    q[64],q[79:65],
    q[48],q[63:49],
    q[32],q[47:33],
    q[16],q[31:17],
    q[0],q[15:1],
    q[240],q[255:241]}; 

    assign southeast = {
    q[238:224],q[239],    
    q[222:208],q[223],
    q[206:192],q[207],    
    q[190:176],q[191],
    q[174:160],q[175],    
    q[158:144],q[159],
    q[142:128],q[143],    
    q[126:112],q[127],
    q[110:96],q[111],    
    q[94:80],q[95],
    q[78:64],q[79],    
    q[62:48],q[63],
    q[46:32],q[47],    
    q[30:16],q[31],    
    q[14:0],q[15],
    q[254:240],q[255]}; 

    wire [1023:0]neighbor;

    
    generate
        genvar i;
        for (i = 0;i<256 ;i=i+1 ) begin:mutiadd
            assign neighbor[4*i+3:4*i] = west[i] + east[i] + north[i] + south[i] + northeast[i] + northwest[i] + southeast[i] + southwest[i]; 
        end
    endgenerate

    wire [255:0] nextstate;
    generate
        genvar j;
        for (j = 0;j<256 ;j=j+1 ) begin:automation
            machine mach(
                        .clk(clk),
                        .load(load),
                        .data(data[j]),
                        .neighbors(neighbor[j*4+3:j*4]),
                        .state(nextstate[j])
                        ); 
        end
    endgenerate

    assign q = nextstate;
endmodule