`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2021 10:45:56 AM
// Design Name: 
// Module Name: Trial_2
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

module Trial_2#(parameter CNT_SIZE = 7, parameter WORD_WIDTH = 32)(input ld_en,rd_en, clk, rst,rst_counter, jump,
                                                                   input [WORD_WIDTH-1:0] Load_data,
                                                                   input [CNT_SIZE-1:0] Jump_to,
                                                                   output [WORD_WIDTH-1:0] instruction,
                                                                   output [CNT_SIZE-1:0] ins_addr);



counter#(.SIZE(CNT_SIZE)) PC(.clk(clk),.rst(rst_counter),.en(rd_en|ld_en),.jump(jump),
                             .data(Jump_to),.count(ins_addr));

Instruction_mem IM(.addr(ins_addr),
                   .data_in(Load_data),.rd_en(rd_en),.wr_en(ld_en),.rst(rst),.clk(clk),
                   .data_out(instruction));  
                   
                   
//processor UUT (.Instruction(instruction),
//               .clk(clk),.rst(rst),
//               .ALU_in1(ALU_in1), .ALU_in2(ALU_in2), .ALU_out(ALU_out),

//                    /////////////// GPR wires
//                    .GRP_out_data1(GRP_out_data1), .GRP_out_data2(GRP_out_data2),.GRP_wr_data(GRP_wr_data),
                
//                    ///////////////DM wires
//                    .DM_data_in(DM_data_in), .DM_data_out(DM_data_out),
//                    .opcode(opcode),
//                    .rs1(rs1), .rs2(rs2), .rd(rd),
//                    .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), .MemtoReg(MemtoReg),
//                    .ALUsrc(ALUsrc), .Branch(Branch),
//                    .ALUop(ALUop),.imm(imm),.ALU_select(ALU_select));
                    
                    


endmodule
