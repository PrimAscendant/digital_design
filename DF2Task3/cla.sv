//`timescale 1ns / 1ps
// Revision 0.3

// 4-Bit Carry-Lookahead Adder
module carry_look_ahead_4bit(
  input logic [3:0] a_in,
  input logic [3:0] b_in,
  input logic c_in,
  output logic [3:0] sum_out,
  output logic c_out
);


  logic [3:0] p;
  logic [3:0] g;
  logic [3:0] temp;

assign p = a_in ^ b_in; // propagate
assign g = a_in & b_in; // generate

  assign temp[0] = c_in;
  assign temp[1] = g[0] | (p[0] & temp[0]);
  assign temp[2] = g[1] | (p[1] & g[0]) | p[1] & p[0] & temp[0];
  assign temp[3] = g[2] | (p[2] & g[1]) | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & temp[0];
  assign c_out = g[3] | (p[3] & g[2]) | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] & temp[0];
assign sum_out = p ^ temp;

endmodule

// N-bit Carry Look Ahead Adder
// multiple of 4
module carry_look_ahead_16bit #(parameter N = 16)(
  input logic [N-1:0] a_in,
  input logic [N-1:0] b_in,
  input logic c_in,
  output logic [N-1:0] sum_out,
  output logic c_out
  );

  logic [4:0] carry;

  assign carry[0] = c_in;

genvar i;
  for (i = 0;i<N;i=i+4) begin : carry_look_ahead_4bit
  carry_look_ahead_4bit FOURBITBLOCK(  
    .sum_out    (sum_out[i +: 4]),
    .c_out  (carry[(i>>2)+1]),
    .a_in      (a_in[i +: 4]),
    .b_in      (b_in[i +: 4]),
    .c_in   (carry[i>>2])
  );

end

assign c_out = carry[4];

      endmodule
