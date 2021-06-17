`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 09:51:31 AM
// Design Name: 
// Module Name: processor
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


////////////////////////////////////////////////
module processor#(parameter WORD_WIDTH =32, parameter CNT_SIZE = 32)(
                                            input ld_en,rd_en, clk, rst,rst_counter,
                                            input [WORD_WIDTH-1:0] Load_data,
                                            
                                            
                                            
                                            /////Program counter outs
                                            output [CNT_SIZE-1:0] pc,pc_1,pc_next,
                                            output Jump_en,
                                            /////
                                            output [WORD_WIDTH-1:0]Instruction,
                                            
                                            /////ALU_outs
                                            output [WORD_WIDTH-1:0] ALU_in1, ALU_in2, ALU_out,
                                            ////Branch_outs
                                            
                                            output  Branch_in1, Branch_in2, Branch_out,
                                            /////////////// GPR wires
                                            output [WORD_WIDTH-1:0] GRP_out_data1, GRP_out_data2,GRP_wr_data,
                                            output [1:0] GRP_in_mux_select,
                                            ///////////////DM wires
                                            output [WORD_WIDTH-1:0] DM_data_in, DM_data_out,
                                            
                                            output [6:0] opcode,
                                            output [4:0] rs1, rs2, rd,
                                            output RegWrite, MemWrite, MemRead, MemtoReg, ALUsrc1, ALUsrc2, Branch,Jump,
                                            output ALUop,
                                            output [31:0] imm,
                                            output [3:0] ALU_select,
                                            output [2:0] Branch_select
);
       
       
       
       
       
                                            

//////////////////Instruction format

///// opcode =>  controls enable and ALU op..basically finds which mode it is.
wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;


wire RegWrite, MemWrite, MemRead, MemtoReg, ALUsrc1, ALUsrc2, Branch,Jump;
wire [1:0] ALUop;
wire [CNT_SIZE-1:0]Jump_to,Ins_addr;
assign Jump_to = ALU_out;

wire Jump_en;

assign Jump_en = ld_en? 1'b0 : ((Branch&Branch_out)|Jump);

counter#(.SIZE(CNT_SIZE)) PC(.clk(clk),.rst(rst_counter),.en(rd_en|ld_en),.jump(Jump_en),
                             .data(Jump_to),.count(pc), .in_final(pc_next),.pc_1(pc_1));

Instruction_mem IM(.addr(pc),
                   .data_in(Load_data),.rd_en(rd_en),.wr_en(ld_en),.rst(rst),.clk(clk),
                   .data_out(Instruction));  



 assign opcode = Instruction[6:0];
 

 assign rd = Instruction[11:7];///also I type
 assign rs1 = Instruction[19:15];///also I type
 assign rs2 = Instruction[24:20];

/////////////opcode connected 


Control_Branch Main_CU(
            .opcode(opcode),
            .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead),
            .MemtoReg(MemtoReg), .ALUsrc1(ALUsrc1), .ALUsrc2(ALUsrc2), .Branch(Branch), .ALUop(ALUop),.Jump(Jump)
            );
////////////////assign instruction to 
///////////////ALU wires
wire [WORD_WIDTH-1:0] ALU_in1, ALU_in2, ALU_out;

/////////////// GPR wires
wire [WORD_WIDTH-1:0] GRP_out_data1, GRP_out_data2,GRP_wr_data;

///////////////DM wires
wire [WORD_WIDTH-1:0] DM_data_in, DM_data_out;


/////////////////////////////////////////////////////////////
DualPortGRP GRP( .rs1(rs1), .rs2(rs2),.rd(rd),
                  .wr_en(RegWrite),.rd_en(1'b1),.clk(clk),.rst(rst),
                  .data_wr(GRP_wr_data),
                  .data_rs1(GRP_out_data1),.data_rs2(GRP_out_data2)
                    );

//////////////////in of ALU => whether from GRP or immediate     

// imm => load and store
wire [31:0] imm;
///change logic of Imm_generator
imm_gen imm_generator(.instruction(Instruction),
                      .imm_extended(imm) ); 
                      
Mux_2#(.WORD_WIDTH(32)) ALU_in1_mux(.a0(GRP_out_data1), .a1(pc),
                               .select(ALUsrc1), 
                               .mux_out(ALU_in1) );            
                                    
Mux_2#(.WORD_WIDTH(32)) ALU_in2_mux(.a0(GRP_out_data2), .a1(imm),
                               .select(ALUsrc2), 
                               .mux_out(ALU_in2) );
                               
/////////////////////////////////////////////////////////h///

wire [3:0] ALU_select;
wire [2:0] Branch_select;
////change logic of alu_control
alu_control ALU_CU(.instruction(Instruction),.alu_op(ALUop),
                   .ALU_select(ALU_select),.Branch_select(Branch_select) );


wire [31:0] Branch_in1, Branch_in2;
wire Branch_out;

assign Branch_in1 = GRP_out_data1;
assign Branch_in2 = GRP_out_data2;
 

Branch_control#(.SIZE(32)) BCU(.data_in1(Branch_in1), .data_in2(Branch_in2),
                           .en(Branch),.select(Branch_select),.data_out(Branch_out));   
                                           
 //(branch&branch_out)|jump will decide the input of pc, i.e if 1 --> alu_out else pc_1                 
                        
ALU #(.SIZE(32)) ALU1(.data_in1(ALU_in1), .data_in2(ALU_in2),
                     .en(1'b1),.select(ALU_select),
                     .data_out(ALU_out),.status());
                     
////////////////////////////////////////////////////////////   

assign DM_data_in = GRP_out_data2;    
        
RAM  #(.WORD_WIDTH(32),.SIZE(128)) DM(.addr(ALU_out[6:0]),
       .data_in(DM_data_in),.rd_en(MemRead),.wr_en(MemWrite),.rst(rst),.clk(clk),
       .data_out(DM_data_out));                     

/////loop back
//////////////////in of GPR => whether from ALU or DM or pc_1

wire [1:0] GRP_in_mux_select;
assign GRP_in_mux_select = {Jump, MemtoReg };

Mux_4#(.WORD_WIDTH(32)) GRP_in_mux(.a0(ALU_out), .a1(DM_data_out), .a2(pc_1),.a3(),
                               .select(GRP_in_mux_select), 
                               .mux_out(GRP_wr_data) );
                               
///////////////////////////////////////////////////////////

endmodule
