`timescale 1ns/1ns
/**********************************RAM************************************/
module dual_port_RAM #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  //深度对2取对数，得到地址的位宽。
	,input [WIDTH-1:0] wdata      	//数据写入
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  //深度对2取对数，得到地址的位宽。
	,output reg [WIDTH-1:0] rdata 		//数据输出
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
end 

endmodule  

/**********************************SFIFO************************************/
module sfifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output reg				wfull	,
	output reg				rempty	,
	output wire [WIDTH-1:0]	rdata
);

    reg[$clog2(DEPTH):0]  r_ptr;
    reg[$clog2(DEPTH):0]  w_ptr;



    dual_port_RAM RAM0(
        .wclk(clk),
        .wenc(winc),
	    .waddr(w_ptr[$clog2(DEPTH)-1:0]),  //深度对2取对数，得到地址的位宽。
	    .wdata(wdata),      	//数据写入
	    .rclk(clk),
	    .renc(rinc),
	    .raddr(r_ptr[$clog2(DEPTH)-1:0]),  //深度对2取对数，得到地址的位宽。
	    .rdata(rdata) 
    );

    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            r_ptr <= 0;
        else if(rinc)begin
            if(r_ptr< DEPTH + DEPTH + 1)
                r_ptr <= r_ptr + 1;
            else
                r_ptr <= {($clog2(DEPTH)+1){1'b0}};    
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            w_ptr <= 0;
        else if(winc)begin
            if(w_ptr< DEPTH + DEPTH + 1)
                w_ptr <= w_ptr + 1;
            else
                w_ptr <= {($clog2(DEPTH)+1){1'b0}};    
        end
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            wfull <= 0;
        else
            wfull <= (w_ptr-r_ptr==DEPTH);
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            rempty <= 0;
        else
            rempty <= (w_ptr == r_ptr);
    end
    
endmodule