//Parameterized N-Bit Adder-Subtractor

module one_bit_full_addr(
  input logic a_i, b_i,
  input logic cin_i,
  output logic sum_o,
  output logic cout_o
);
  logic temp_sum;
  assign temp_sum = a_i ^ b_i; 
  assign sum_o = temp_sum ^ cin_i;
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
  
  assign b_sub = b_i ^ sub_i;

  genvar i;
  generate // This will instantial one_bit_full_addr N-1 times
  
    for(i = 0; i<N; i++) begin
    if(i==0)begin
      one_bit_full_addr fa0(a_i[0], b_sub[0], sub_i, sum_o[0], carry[0]);
  end
    else begin
      one_bit_full_addr fa(a_i[i], b_sub[i], carry[i-1], sum_o[i], carry[i]);
    end
      end
   endgenerate
  
  assign cout_o = carry[N-1];
endmodule
