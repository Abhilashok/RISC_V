`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2021 09:48:31 AM
// Design Name: 
// Module Name: Instruction_mem
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


////////////////////////////////////////////////////////
module D_FF(input clk, rst, en, D,
            output reg Q,Q1);

always @( posedge clk)
    begin
    if(rst)
        begin
        Q <= 1'b0; 
        end
    else if (en)
        begin
        Q <= D;
        end
    end
    
always@*
    begin
    Q1 = ~Q;
    end
   
endmodule

///////////////////////////////////////////////
module counter#(parameter SIZE = 32)(input clk,rst,en,jump,
                          input [SIZE-1:0]data,
                          output [SIZE-1:0] pc_1,
                          output [SIZE-1:0] in_final,
                          output [SIZE-1:0]count);

wire [SIZE-1:0] in;
wire [SIZE-1:0] out1; 


//D_FF PC(.clk(clk), .rst(rst), .en(en), .D(en&),
//           .Q(count[i]),.Q1());

assign in[0] =  en;
genvar i;
generate 
    for (i = 0 ;i < SIZE; i=i+1)
        begin 
        assign pc_1[i] = in[i]^count[i];
        assign in_final [i] = jump ? data [i] : pc_1[i];
        D_FF PC(.clk(clk), .rst(rst), .en(en), .D(in_final[i]),
           .Q(count[i]),.Q1(out1[i]));
        assign in[i+1] = count[i]&in[i] ;
        end
endgenerate


endmodule
////////////////////////////////////////////////////////

///////////////////////////////////////////////////////

module Instruction_mem#(parameter CNT_SIZE = 32)(input [CNT_SIZE-1:0]addr,
            input data_in,rd_en,wr_en,rst,clk,
           output data_out);  
           
 wire [31:0] data_in;
 wire [31:0] data_out;      
     
RAM #(.WORD_WIDTH(32),.SIZE(128)) IM(.addr(addr),
            .data_in(data_in),.rd_en(rd_en),.wr_en(wr_en),.rst(rst),.clk(clk),
            .data_out(data_out));
    
endmodule
