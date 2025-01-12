module one_bit_full_addr(
  input wire a, b,
  input wire cin,
  output wire sum,
  output wire cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a^b));
endmodule 

module four_bit_full_adder(
  input wire [3:0] a, b,
  input wire cin,
  output wire [3:0] sum,
  output wire cout);
  
  wire c1,c2,c3;
  
  one_bit_full_addr fa0(a[0],b[0],cin,sum[0],c1);
  one_bit_full_addr fa1(a[1],b[1],c1,sum[1],c2);
  one_bit_full_addr fa2(a[2],b[2],c2,sum[2],c3);
  one_bit_full_addr fa3(a[3],b[3],c3,sum[3],cout);

endmodule
