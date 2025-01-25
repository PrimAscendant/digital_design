//4x4 Array Multiplier
module one_bit_and(
  input  logic a_i,
  input  logic b_i,
  output logic c_o
);

  assign c_o = a_i & b_i;
endmodule


module array_multiplier #(parameter N = 4) (
  input  logic [N-1:0] a_i,
  input  logic [N-1:0] b_i,
  output logic [2*N-1:0] product_o
);

  logic [N-1:0] pp_row [N-1:0];
  logic [2*N-1:0] shifted_row [N-1:0];
  logic [2*N-1:0] sum0, sum1;
  
  genvar i, j;

  generate
    for(i = 0; i < N; i++) begin : gen_pp_row
      for(j = 0; j < N; j++) begin : gen_pp_bit
        one_bit_and fa(a_i[j],b_i[i],pp_row[i][j]);
      end
    end
  endgenerate 
  // Left-shift each row by i bits
  generate
    for(i = 0; i < N; i++) begin : gen_shifts
      assign shifted_row[i] = {{(N - i){1'b0}}, pp_row[i], {i{1'b0}}};
    end
  endgenerate
  // Two-level addition of shifted rows
  assign sum0 = shifted_row[0] + shifted_row[1];
  assign sum1 = shifted_row[2] + shifted_row[3];
  assign product_o = sum0 + sum1;

endmodule

