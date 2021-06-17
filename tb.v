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


module tb#(parameter WORD_WIDTH =32);
    reg [WORD_WIDTH-1:0] Instruction;
    reg clk,rst;
    wire [WORD_WIDTH-1:0] ALU_in1, ALU_in2, ALU_out;

    /////////////// GPR wires
    wire [WORD_WIDTH-1:0] GRP_out_data1, GRP_out_data2,GRP_wr_data;

    ///////////////DM wires
    wire [WORD_WIDTH-1:0] DM_data_in, DM_data_out;
    
    wire [6:0] opcode;
    wire [4:0] rs1, rs2, rd;
    wire RegWrite, MemWrite, MemRead, MemtoReg, ALUsrc, Branch;
    wire [1:0] ALUop;
    wire [31:0] imm;
    wire [3:0] ALU_select;

    
    
    processor UUT (.Instruction(Instruction),
                     .clk(clk),.rst(rst),
                     .ALU_in1(ALU_in1), .ALU_in2(ALU_in2), .ALU_out(ALU_out),

                    /////////////// GPR wires
                    .GRP_out_data1(GRP_out_data1), .GRP_out_data2(GRP_out_data2),.GRP_wr_data(GRP_wr_data),
                
                    ///////////////DM wires
                    .DM_data_in(DM_data_in), .DM_data_out(DM_data_out),
                    .opcode(opcode),
                    .rs1(rs1), .rs2(rs2), .rd(rd),
                    .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), .MemtoReg(MemtoReg),
                    .ALUsrc(ALUsrc), .Branch(Branch),
                    .ALUop(ALUop),.imm(imm),.ALU_select(ALU_select));
                
    
    
    initial
        begin
        clk <= 1'b1;
        rst <= 1'b1;
        
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
        #1000
        
        $display("start");
        
        
        
        #20
        rst <= 1'b0;
        
        #20
        //instruction <= 0000 0000 1010 | 00000 | 000 | 10100 | 0111 011 
        Instruction<=32'h00A00A3B;
        
      

        #20  
        //instruction <= 0000 0000 0101 | 00000 | 000 | 10101 | 0111 011  
        Instruction<=32'h00500ABB;
        
     
        
        
        
        #20
        //instruction <= 0000 000 | 10100 | 10101 | 000 | 10110 | 0110 011  
        Instruction<=32'h014A8B33;
        
        #20
        //instruction <= 0000 000 | 10110 | 00000 | 000 | 11001 | 0100 011  
        Instruction<=32'h01600CA3;
        
        #20
        //instruction <= 0000 0001 1001 | 00000 | 000 | 11001 | 0000 011  
        Instruction<=32'h01900C83;

        #10
          $display("end");
        
        
        end
        
        

   
endmodule