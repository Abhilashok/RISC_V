`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2021 10:01:42 AM
// Design Name: 
// Module Name: tb
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


module tb_2 #(parameter WORD_WIDTH =32,
                parameter CNT_SIZE = 32);
//
//reg [6:0] Jump_to;
//reg [WORD_WIDTH-1:0] Load_data;
//wire [WORD_WIDTH-1:0] Instruction;
//wire [6:0] ins_addr;


//Trial_2#(.CNT_SIZE(7),.WORD_WIDTH(32)) IM (.ld_en(ld_en),.rd_en(rd_en), .clk(clk), .rst(rst),.rst_counter(rst_counter), .jump(jump),.Jump_to(Jump_to),
//                                            .Load_data(Load_data),.instruction(Instruction),.ins_addr(ins_addr));
reg ld_en,rd_en, clk, rst, rst_counter;

reg [WORD_WIDTH-1:0] Load_data;
//wire [WORD_WIDTH-1:0] Instruction;
//wire [6:0] ins_addr;
 
wire [WORD_WIDTH-1:0] Instruction;
wire [CNT_SIZE-1:0] pc, pc_1,pc_next;
wire Jump_en;
wire [WORD_WIDTH-1:0] Branch_in1, Branch_in2;
wire Branch_out;
wire [WORD_WIDTH-1:0] ALU_in1, ALU_in2, ALU_out;

/////////////// GPR wires
wire [WORD_WIDTH-1:0] GRP_out_data1, GRP_out_data2,GRP_wr_data;
wire [1:0] GRP_in_mux_select;
///////////////DM wires
wire [WORD_WIDTH-1:0] DM_data_in, DM_data_out;

wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;
wire RegWrite, MemWrite, MemRead, MemtoReg, ALUsrc1, ALUsrc2, Branch,Branch_out, Jump;
wire [1:0] ALUop;
wire [31:0] imm;
wire [3:0] ALU_select;   
wire [2:0] Branch_select;
    
     processor  #(.WORD_WIDTH(32), .CNT_SIZE(32)) UUT(
                                            .ld_en(ld_en),.rd_en(rd_en), .clk(clk), .rst(rst),.rst_counter(rst_counter),
                                            .Load_data(Load_data),
                                            
                                            
                                            
                                            /////Program counter outs
                                            .pc(pc),.pc_1(pc_1),.pc_next(pc_next),
                                            .Jump_en(Jump_en),
                                            
                                            /////
                                            .Instruction(Instruction),
                                            
                                            /////ALU_outs
                                            .ALU_in1(ALU_in1), .ALU_in2(ALU_in2), .ALU_out(ALU_out),
                                            ////Branch_outs
                                            
                                            .Branch_in1(Branch_in1), .Branch_in2(Branch_in2), .Branch_out(Branch_out),
                                            /////////////// GPR wires
                                            .GRP_out_data1(GRP_out_data1), .GRP_out_data2(GRP_out_data2),.GRP_wr_data(GRP_wr_data),
                                            .GRP_in_mux_select(GRP_in_mux_select),
                                            ///////////////DM wires
                                            .DM_data_in(DM_data_in), .DM_data_out(DM_data_out),
                                            
                                            
                                            ///////////////////////////
                                            .opcode(opcode),
                                            .rs1(rs1), .rs2(rs2), .rd(rd),
                                            .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), .MemtoReg(MemtoReg),
                                            .ALUsrc1(ALUsrc1),.ALUsrc2(ALUsrc2), .Branch(Branch),.Jump(Jump),
                                            .ALUop(ALUop),.imm(imm),.ALU_select(ALU_select),.Branch_select(Branch_select)
                                        
);
    initial
        begin
        clk <= 1'b1;
        rst <= 1'b1;
        rst_counter<=1'b1;
        end
        
        
    always #10 clk = ~clk;
    
//    always@(posedge clk)
//        begin
//        $display("data_wr = %h",data_wr);
//        $display("data_rs1 = %h",data_rs1);
//        $display("data_rs2 = %h",data_rs2);
        
//        end
    
        
    initial
        begin
        #640
        
        $display("start");
        
        
        
        #20
        rst <= 1'b0;
        rst_counter <= 1'b0;
        ld_en<= 1'b1;
        rd_en<=1'b0;
        //a = 10
        //instruction <= 0000 0000 1010 | 00000 | 000 | 10010 | 0101 001 
        Load_data<=32'h00A00929;
        
      

        #20  
        //b = 5
        //instruction <= 0000 0000 0101 | 00000 | 000 | 10011 | 0101 001   
        Load_data<=32'h005009A9;
        
        
        #20 
        //c = 11 
        //instruction <= 0000 0000 1011 | 00000 | 000 | 10100 | 0101 001   
        Load_data<=32'h00B00A29;
        
        
        #20
        //d = a + b
        //instruction <= 0000 000 | 10010 | 10011 | 000 | 10101 | 0000 001  
        Load_data<=32'h01298A81;
        
        #20
        //if( d < c) 
        //instruction <= 0000 000 | 10100 | 10101 | 011 | 00101 | 1010 011  
        Load_data<=32'h014AB2D3;
        
        #20
        // when abv condition is False
        // d = d + 10
        //instruction <= 0000 0000 1010 | 10101 | 000 | 10101 | 0101 001  
        Load_data<=32'h00AA8AA9;
        
        #20
        //store d to 8 in DM
        //instruction <= 0000 000 | 10101 | 00000 | 000 | 01000 | 1001 010 
        Load_data<=32'h0150044A;
        
        #20
        //load d to 27 i GPR 
        //instruction <= 0000 0000 1000 | 00000 | 000 | 11011 | 0101 010
        Load_data<=32'h00800DAA;
        
        #20
        //JALR to 12
        //JALR 1(x18) x1
        //instruction <= 0000 0000 0001 | 10010 | 000 | 00001 | 1011 011
        Load_data<=32'h001900DB;
        
        
        #20
        ////if branch is True
        //d = d - 10
        //instruction <= 0000 0000 1010 | 10101 | 001 | 10101 | 0101 001
        Load_data<=32'h00AA9AA9;
        
        #20
        //jump to 6
        //JAL (-4) x1
        //instruction <= 1111 1111 1111 1111 1110 | 00010 | 1111 011
        Load_data<=32'hFFFFE17B;
        #20
        //RI 15(x0) x25
        //instruction <= 0000 0000 1111 | 00000 | 000 | 10010 | 0101 001 
        Load_data<=32'h00F00929;
        
        
        #20
        ld_en<= 1'b0;
        rd_en<=1'b1;
        rst_counter <= 1'b1;
        
        #20
        rst_counter<= 1'b0;
        
        
        #60
       
        
        
        #20
        
         
        #10
          $display("end");
          
       
        
        
        end
        
        

   
endmodule