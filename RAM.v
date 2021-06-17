`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2021 09:35:55 AM
// Design Name: 
// Module Name: RAM
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


//////////////////////////////////////////////

module demux_128(
                input en, 
                input [6:0] select,
                output [127:0] demux_out);
        
        wire [3:0] en_select  ;     
                
        demux_4 d1( 
                    .en(en),
                    .select(select[6:5]),
                    .demux_out(en_select[3:0]));   
                    
                    
        demux_32 d2( 
                    .en(en_select[3]),
                    .select(select[4:0]),
                    .demux_out(demux_out[127:96]));
                    
        demux_32 d3( 
                    .en(en_select[2]),
                    .select(select[4:0]),
                    .demux_out(demux_out[95:64]));
                    
        demux_32 d4(
                    .en(en_select[1]),
                    .select(select[4:0]),
                    .demux_out(demux_out[63:32]));
                    
        demux_32 d5( 
                    .en(en_select[0]),
                    .select(select[4:0]),
                    .demux_out(demux_out[31:0]));
endmodule

/////////////////////////////////////////////////////////////////////////////////////
module RAM #(parameter WORD_WIDTH = 32, parameter SIZE = 128)(input [6:0] addr,
            input data_in,rd_en,wr_en,rst,clk,
           output data_out);  
          
 wire [WORD_WIDTH-1:0] data_in;
 wire [WORD_WIDTH-1:0] data_out;        
 
 
 wire [WORD_WIDTH-1:0] data_wire [SIZE-1:0];

 wire [SIZE-1:0] reg_wr_en;   
 wire [SIZE-1:0] reg_rd_en;
 
                
demux_128 reg_demux_wr(.en(wr_en),.select(addr), 
                .demux_out(reg_wr_en));          
demux_128 reg_demux_rd(.en(rd_en),.select(addr), 
                .demux_out(reg_rd_en));  
           
 genvar i;
 
 generate    
    begin
    for(i = 0; i < SIZE; i=i+1 )
        begin
        
        register RAM_Reg(.en(reg_wr_en[i]), .rst(rst),  .clk(clk),
                .data_in(data_in), .data(data_wire[i]));
        tristatebuffer TSB1(.data_in(data_wire[i]),
                        .en(reg_rd_en[i]),
                        .data_out(data_out));
        end
    end
 endgenerate 
 
      
endmodule
             
/////////////////////////////////////////////////////
