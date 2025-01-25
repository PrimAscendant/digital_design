//Parameterized N-Bit Adder-Subtractor
module one_bit_full_addr(
  input logic a_i, b_i,
  input logic cin_i,
  output logic sum_o,
  output logic cout_o
);
  
  assign sum_o = a_i ^ b_i ^ cin_i;
  assign cout_o = (a_i & b_i) | (cin_i & (a_i ^ b_i));
endmodule

module adder_subtractor #(parameter N = 4) (
  input logic [N-1:0] a_i, b_i, 
  input logic sub_i,
  output logic [N-1:0] sum_o,
  output logic cout_o
);
  logic [N-1:0] carry;
  logic [N-1:0] b_sub;

  genvar i;
  
  generate
    for(i = 0; i<N; i++) begin
      assign b_sub[i] = b_i[i] ^ sub_i;
    end
  endgenerate
  
  one_bit_full_addr fa0(a_i[0], b_sub[0], sub_i, sum_o[0], carry[0]);
  
  generate  // This will instantial one_bit_full_addr N-1 times
    for(i = 1; i<N; i++) begin
     
      one_bit_full_addr fa(a_i[i], b_sub[i], carry[i-1], sum_o[i], carry[i]);
    end
  endgenerate
  assign cout_o = carry[N-1];
endmodule
