// 4-Bit Ripple Carry Adder
module one_bit_full_addr(
  input logic a_i, b_i,
  input logic cin_i,
  output logic sum_o,
  output logic cout_o
);
  assign sum_o = a_i ^ b_i ^ cin_i;
  assign cout_o = (a_i & b_i) | (cin_i & (a_i^b_i));
endmodule

module four_bit_full_adder #(parameter BIT_WIDTH = 4)(
  input logic [BIT_WIDTH-1:0] a_i, b_i,
  input logic cin_i,
  output logic [BIT_WIDTH-1:0] sum_o,
  output logic cout_o
);
  
  logic [BIT_WIDTH-1:0] carry;
  
  genvar i;
  generate
    for(i=0; i < BIT_WIDTH; i++)begin : ADDER
    if(i == 0)
      one_bit_full_addr fa(a_i[i],b_i[i],cin_i,sum_o[i],carry[i]);
    else if(i == BIT_WIDTH -1 )
      one_bit_full_addr fa(a_i[i],b_i[i],carry[i-1],sum_o[i],carry);
    else
      one_bit_full_addr fa(a_i[i],b_i[i],carry[i-1],sum_o[i],carry[i]);
    end
  endgenerate
  assign cout_o = carry[BIT_WIDTH-1];
/*
// Alternate >= 4-bit simple example without generate:
  wire c1,c2,c3;

  one_bit_full_addr fa0(a[0],b[0],cin,sum[0],c1);
  one_bit_full_addr fa1(a[1],b[1],c1,sum[1],c2);
  one_bit_full_addr fa2(a[2],b[2],c2,sum[2],c3);
  one_bit_full_addr fa3(a[3],b[3],c3,sum[3],cout);
*/
endmodule






