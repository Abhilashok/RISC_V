`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2021 08:35:53 AM
// Design Name: 
// Module Name: ALU
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



//////////////////////////////////////////////////////////////////////////

//module FA(input a,b,cin, 
//          output sum, cout);

//  assign sum = a^b^cin;
//  assign cout = a&b|b&cin|a&cin;

//endmodule

//module FA_32(input [31:0] a,b,cin,
//             output [31:0] sum,
//             output cout) ; 
  
//  wire [32:0] carry;
//  assign carry[0] = cin;
//  assign cout = carry[32];
//  genvar i;
//  generate
//    begin:Adder_block
//      for(i = 0; i<32 ;i = i+1)
//        begin
//        FA adder(.a(a[i]),.b(b[i]),.cin(carry[i]),
//                 .sum(sum[i]),.cout(carry[i+1]));
//        end
//    end
//  endgenerate
//endmodule

//module Add_Sub_32(input [31:0] a,b,
//             input [1:0] select, 
//             output [31:0] sum,
//             output cout);
             
//wire cin_1, cin_2;
//wire [31:0] sum_1, sum_2;
//wire cout_1, cout_2;

//assign cin_1 = select[0]|select[1];
//assign cin_2 = select[0]&select[1];

//FA_32 adder1(.a(a^select[1]),.b(b^select[0]),.cin(cin_1),
//             .sum(sum_1),.cout(cout_1));
//FA_32 adder2(.a(sum_1),.b(32'b0),.cin(cin_2),
//             .sum(sum_2),.cout(cout_2));


//endmodule
///////////////////////////////////////////////////////////////////////////

//module shift_r#(parameter SIZE = 32)(input [SIZE-1:0] data_in,
//                                     output [SIZE-1:0] data_out,
//                                     output carry);


//assign data_out = {0, data_in[SIZE-1:1]};
//assign carry = data_in[0] ;
 
//endmodule                                  
//module shift_l#(parameter SIZE = 32)(input [SIZE-1:0] data_in, 
//                                     output [SIZE-1:0] data_out,
//                                     output carry);


// assign data_out = {data_in[SIZE-2:0],0};
// assign carry = data_in[SIZE-1] ;
 
//endmodule    
////////////////////////////////////////////////////////////////////////////

module ALU#(parameter SIZE = 32)(input [SIZE-1:0] data_in1, data_in2,
                                 input en,
                                 input [3:0] select,
                                 output reg [SIZE-1:0] data_out,
                                 output reg [2:0] status);
                                 
//wire [SIZE-1 : 0] comp_data [0:5] ;
//wire [5:0] buffer_en ;

//Add_Sub_32 Add_Sub( .a(data_in1),.b(data_in2),
//             .select(select[1:0]), 
//             .sum(comp_data[0]),.cout(status[0]));
//shift_r  #(.SIZE(32)) r_shift(.data_in(data_in1),
//                      .data_out(comp_data[1]),
//                      .carry(status[1]));
//shift_l #(.SIZE(32)) l_shift( .data_in(data_in1), 
//                               .data_out(comp_data[2]),
//                               .carry(status[2]));   
                               
//assign comp_data[3] = data_in1 & data_in2;
//assign comp_data[4] = data_in1 | data_in2;
//assign comp_data[5] = ~data_in1;                            
                                    
//demux_8 out_en(
//            .en(en), 
//            .select({select[3],select[1:0]}),
//            .demux_out(buffer_en[5:1]));
// assign buffer_en[0] = ~(select[2]|select[1]);              
            
//genvar i;            
        
//generate      
//    for (i = 0; i < 6 ; i = i+1)
//    begin       
//    tristatebuffer ALU_tristate(  .data_in(comp_data[i]),.en(buffer_en[i]),
//                 .data_out(data_out));
//    end
//endgenerate



always@*
    begin
    if (en)
        begin
        case(select)
            00: data_out <= data_in1 + data_in2;          //and
            01: data_out <= data_in1 - data_in2;          //or
            02: data_out <= data_in1 & data_in2;          // add
            03: data_out <= data_in1 | data_in2;          //subtraction
            04: data_out <= (data_in1 == data_in2) ? 1:0; // equality check
            05: data_out <= ~(data_in1 & data_in2);      // nanad
            06: data_out <= ~(data_in1 | data_in2);      // nor
            07: data_out <= data_in1  << 1     ;          //shift
            08: data_out <= data_in2  << 1;
            09: data_out <= data_in1  <<< 1   ;           // rotate
            10: data_out <= data_in2  <<< 1;
          default data_out <= 32'bz;
          endcase
       end
    end
endmodule


module Branch_control#(parameter SIZE = 32)(input [SIZE-1:0] data_in1, data_in2,
                                 input en,
                                 input [2:0] select,
                                 output reg  data_out);
                                 
//wire [SIZE-1 : 0] comp_data [0:5] ;
//wire [5:0] buffer_en ;

//Add_Sub_32 Add_Sub( .a(data_in1),.b(data_in2),
//             .select(select[1:0]), 
//             .sum(comp_data[0]),.cout(status[0]));
//shift_r  #(.SIZE(32)) r_shift(.data_in(data_in1),
//                      .data_out(comp_data[1]),
//                      .carry(status[1]));
//shift_l #(.SIZE(32)) l_shift( .data_in(data_in1), 
//                               .data_out(comp_data[2]),
//                               .carry(status[2]));   
                               
//assign comp_data[3] = data_in1 & data_in2;
//assign comp_data[4] = data_in1 | data_in2;
//assign comp_data[5] = ~data_in1;                            
                                    
//demux_8 out_en(
//            .en(en), 
//            .select({select[3],select[1:0]}),
//            .demux_out(buffer_en[5:1]));
// assign buffer_en[0] = ~(select[2]|select[1]);              
            
//genvar i;            
        
//generate      
//    for (i = 0; i < 6 ; i = i+1)
//    begin       
//    tristatebuffer ALU_tristate(  .data_in(comp_data[i]),.en(buffer_en[i]),
//                 .data_out(data_out));
//    end
//endgenerate



always@*
    begin
    if (en)
        begin
        case(select)
            00: data_out <= (data_in1 == data_in2) ? 1:0; // equal check
            01: data_out <= (data_in1 == data_in2) ? 0:1; // not equal check
            02: data_out <= (data_in1 > data_in2) ? 1:0; // greater than check
            03: data_out <= (data_in1 < data_in2) ? 1:0; // less than check
            04: data_out <= (data_in1 < data_in2) ? 0:1; // greater than or equal check
            05: data_out <= (data_in1 > data_in2) ? 0:1;     // nanad
            
          default data_out <= 1'bz;
       endcase
       end
    end
endmodule