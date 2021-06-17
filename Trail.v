`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2021 09:39:28 AM
// Design Name: 
// Module Name: Trail
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_2#(parameter WORD_WIDTH = 32)(input [WORD_WIDTH-1 : 0] a0, a1,
                                    input select, 
                                    output [WORD_WIDTH-1 : 0] mux_out );
  
assign mux_out = select ? a1 : a0;

endmodule

module Mux_4#(parameter WORD_WIDTH = 32)(input [WORD_WIDTH-1 : 0] a0, a1, a2, a3,
                                        input [1:0] select, 
                                        output [WORD_WIDTH-1 : 0] mux_out );
wire [WORD_WIDTH-1:0] mux_3_2,mux_1_0; 

/////layer1 
Mux_2#(.WORD_WIDTH(32)) mux11(.a0(a2), .a1(a3),
                               .select(select[0]), 
                               .mux_out(mux_3_2) );
Mux_2#(.WORD_WIDTH(32)) mux12(.a0(a0), .a1(a1),
                               .select(select[0]), 
                               .mux_out(mux_1_0) );
                               
/////layer2                               
Mux_2#(.WORD_WIDTH(32)) mux21(.a0(mux_1_0), .a1(mux_3_2),
                               .select(select[1]), 
                               .mux_out(mux_out) );

endmodule

module register(input en, rst,  clk,
                input [31:0] data_in,
                output reg [31:0] data
                );


always@(posedge clk)
    begin
    if (rst)
        begin
        data <= 32'b0;
        end
    else if (en)
        begin
        data <= data_in ;
        end
    
    end
endmodule

///////////////////////////////////////////////////////////////////////////
module demux_4(
            input en,
            input [1:0] select,
            output [3:0] demux_out);
            
        
        assign demux_out[0] = en &~select[1] &~select[0] ;
        assign demux_out[1] = en &~select[1] & select[0] ;
        assign demux_out[2] = en & select[1] &~select[0] ;
        assign demux_out[3] = en & select[1] & select[0] ;
            
endmodule

///////////////////////////////////////////////////////////////////////////

module demux_8(
            input en, 
            input [2:0] select,
            output [7:0] demux_out);
        
        wire [1:0] en_select;
        
        assign en_select[0] = en & ~select[2]  ;
        assign en_select[1] = en &  select[2]  ;
        
            
        demux_4 d1( 
                    .en(en_select[1]),
                    .select(select[1:0]),
                    .demux_out(demux_out[7:4]));
        demux_4 d2( 
                    .en(en_select[0]),
                    .select(select[1:0]),
                    .demux_out(demux_out[3:0]));
                   
endmodule

////////////////////////////////////////////////////////////////////////////////

module demux_32(
                input en, 
                input [4:0] select,
                output [31:0] demux_out);
        
        wire [3:0] en_select  ;     
                
        demux_4 d1( 
                    .en(en),
                    .select(select[4:3]),
                    .demux_out(en_select[3:0]));   
                    
                    
        demux_8 d2( 
                    .en(en_select[3]),
                    .select(select[2:0]),
                    .demux_out(demux_out[31:24]));
                    
        demux_8 d3( 
                    .en(en_select[2]),
                    .select(select[2:0]),
                    .demux_out(demux_out[23:16]));
                    
        demux_8 d4(
                    .en(en_select[1]),
                    .select(select[2:0]),
                    .demux_out(demux_out[15:8]));
                    
        demux_8 d5( 
                    .en(en_select[0]),
                    .select(select[2:0]),
                    .demux_out(demux_out[7:0]));
endmodule
////////////////////////////////////////////////////////////////////////
module tristatebuffer(  input [31:0] data_in,
                        input en,
                        output[31:0] data_out);

    assign data_out = en?data_in : 32'bz;
endmodule
//////////////////////////////////////////////////////////////////////


module DualPortGRP(
                    input [4:0] rs1, rs2,rd,
                    input wr_en,rd_en,clk,rst,
                    input [31:0] data_wr,
                    output [31:0] data_rs1,data_rs2
                    );
                    
                    
                    
    wire [31:0] data_z [0:31];
    
    wire [31:0] reg_en, rd_en1, rd_en2;
    wire [31:0] data_in, data_out1, data_out2;
    
    
    assign data_in = data_wr;
    
    demux_32 wr_d1(.en(wr_en), 
                .select(rd),
                .demux_out(reg_en) );
                
    demux_32 rd_d1(.en(rd_en), 
                .select(rs1),
                .demux_out(rd_en1) );
    demux_32 rd_d2(.en(rd_en), 
                .select(rs2),
                .demux_out(rd_en2) );
                
    genvar  i;
    generate
        for (i=0; i< 32; i = i+1)
        begin: RegisterBlock
        register GRP( .en(reg_en[i]), .rst(rst),  .clk(clk),
                      .data_in(data_in),.data(data_z[i]));
        tristatebuffer TSB1(.data_in(data_z[i]),
                        .en(rd_en1[i]),
                        .data_out(data_out1));
        tristatebuffer TSB2(.data_in(data_z[i]),
                        .en(rd_en2[i]),
                        .data_out(data_out2));
        end
    endgenerate
    
    
    assign data_rs1 = data_out1;
    assign data_rs2 = data_out2;
endmodule

///////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////  

//module mux_2(input select, data_in,
//            output [31:0] data_out);   
//endmodule      






