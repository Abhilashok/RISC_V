`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2021 12:52:00 PM
// Design Name: 
// Module Name: CU
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


module  Control_Branch(input [6:0] opcode,
            //// opcode =>  controls enable
           output reg RegWrite, MemWrite, MemRead, MemtoReg, ALUsrc1, ALUsrc2, Branch,Jump,
           output reg [1:0] ALUop
            );
            
            
 
 
 always@* 
    begin
     /////R type//////
    if (opcode == 7'b0000001)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b0;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b1;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        ALUop <= 2'b00;
        end  
      /////R_immediate type//////
    else if (opcode == 7'b0101001)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b1;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        ALUop <= 2'b01;///00 bcz we dont hv func 7
        end
        
      /////Load_Upper_immediate type//////
    else if (opcode == 7'b1111001)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b1;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        ALUop <= 2'b11;///11 bcz we dont hv func 7 and func 3
        end
     
     
        /////load//////
    else if (opcode == 7'b0101010)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b1;
        RegWrite <= 1'b1;
        MemRead <= 1'b1;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        ALUop <= 2'b01;
        end
        ///////store//////
    else if (opcode == 7'b1001010)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b1;
        Branch <= 1'b0;
        Jump <= 1'b0;
        ALUop <= 2'b01;
        end
        /////// branch_condition ///////
     else if (opcode == 7'b1010011)
        begin
        ALUsrc1 <= 1'b1;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b1;
        Jump <= 1'b0;
        ALUop <= 2'b10;
        end
     
          
     /////// JAL ///////
     else if (opcode == 7'b1111011)
        begin
        ALUsrc1 <= 1'b1;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b1;
        Branch <= 1'b0;
        Jump <= 1'b1;
        ALUop <= 2'b11;
        end
        
     /////// JALR ///////
     else if (opcode == 7'b1011011)
        begin
        ALUsrc1 <= 1'b0;
        ALUsrc2 <= 1'b1;
        MemtoReg <= 1'b0;
        RegWrite <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b1;
        Branch <= 1'b0;
        Jump <= 1'b1;
        ALUop <= 2'b11;
        end
     
    end      
 
endmodule

/////////////////////////////////////////////////////
module imm_gen(input [31:0] instruction,

           // imm => load and store
            output reg [31:0] imm_extended );
reg [11:0] imm_12;
reg [19:0] imm_20;
always@* 
    begin
    if (instruction[6:5] == 2'b01)
        begin
        imm_12 = instruction[31:20];
        imm_extended = {{20{imm_12[11]}}, imm_12};
        end
    else if(instruction[6:5] == 2'b10)
        begin
        imm_12 = {instruction[31:25],instruction[11:7]};
        imm_extended = {{20{imm_12[11]}}, imm_12};
        end
    else if(instruction[6:5] == 2'b11)
        begin
        imm_20 = {instruction[31:12]};
        /////if jump and reg
        if (instruction[2:0] == 3'b011)
            begin
            imm_extended = {{12{imm_20[19]}},imm_20};
            end
        else if (instruction[2:0] == 3'b001)
            begin
            
            imm_extended = {imm_20, 12'b0};
            end
    
         end
   end
    
endmodule

module alu_control(input [31:0] instruction,
                   input [1:0] alu_op,
                   output reg [3:0] ALU_select , 
                   output reg [2:0] Branch_select);

reg [2:0] func3;
reg [6:0] func7;


always@*
    begin
    func3 = instruction[14:12];
    func7 = instruction[31:25];

    if (alu_op == 2'b00)
        begin
        
        if (func7 == 0)
            begin
            if (func3 == 0)
                begin
            ALU_select = 0;
                end  
            else if (func3 == 1)
                begin
            ALU_select = 1;
                end
            else if (func3 == 2)
                begin
            ALU_select = 2;
                end
            else if (func3 == 3)
                begin
            ALU_select = 3;
                end
            else if (func3 == 4)
                begin
            ALU_select = 4;
                end
            else if (func3 == 5)
                begin
            ALU_select = 5;
                end
            else if (func3 == 6)
                begin
            ALU_select = 6;
                end
            else if (func3 == 7)
                begin
            ALU_select = 7;
                end
            end
            
        
            
      else if (func7 == 32)
      begin
            if (func3 == 0)
                begin
            ALU_select = 8;
                end  
            else if (func3 == 1)
                begin
            ALU_select = 9;
                end
            else if (func3 == 2)
                begin
            ALU_select = 10;
                end
            else if (func3 == 3)
                begin
            ALU_select = 11;
                end
            else if (func3 == 4)
                begin
            ALU_select = 12;
                end
            else if (func3 == 5)
                begin
            ALU_select = 13;
                end
            else if (func3 == 6)
                begin
            ALU_select = 14;
                end
            else if (func3 == 7)
                begin
            ALU_select = 15;
                end
        end 
    end 
    else if (alu_op == 2'b01)
        begin
       if (func3 == 0)
                begin
            ALU_select = 0;
                end  
            else if (func3 == 1)
                begin
            ALU_select = 1;
                end
            else if (func3 == 2)
                begin
            ALU_select = 2;
                end
            else if (func3 == 3)
                begin
            ALU_select = 3;
                end
            else if (func3 == 4)
                begin
            ALU_select = 4;
                end
            else if (func3 == 5)
                begin
            ALU_select = 5;
                end
            else if (func3 == 6)
                begin
            ALU_select = 6;
                end
            else if (func3 == 7)
                begin
            ALU_select = 7;
                end
                
        end
    else if (alu_op == 2'b10)
        begin
        ALU_select = 0;
        if (func3 == 0)
            begin
            Branch_select = 0;
            end  
        else if (func3 == 1)
            begin
            Branch_select = 1;
            end
        else if (func3 == 2)
            begin
            Branch_select = 2;
            end
        else if (func3 == 3)
            begin
            Branch_select = 3;
            end
        else if (func3 == 4)
            begin
            Branch_select = 4;
            end
        else if (func3 == 5)
            begin
            Branch_select = 5;
            end
        else if (func3 == 6)
            begin
        Branch_select = 6;
            end
        else if (func3 == 7)
            begin
        Branch_select = 7;
            end
        end
    else if (alu_op == 2'b11)
        begin
        ALU_select = 0;
        end
end
      

 endmodule           