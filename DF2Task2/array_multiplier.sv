module array_multiplier #(parameter N = 4) (
  input  logic [N-1:0] a_i,
  input  logic [N-1:0] b_i,
  output logic [2*N-1:0] product_o
);

  logic [N-1:0] pp_row [N-1:0];
  logic [2*N-1:0] shifted_row [N-1:0];
  logic [2*N-1:0] sum0 [0:N];
  
  genvar i, j;

  generate
    for(i = 0; i < N; i++) begin : gen_pp_row
      for(j = 0; j < N; j++) begin : gen_pp_bit
        assign pp_row[i][j] = a_i[j] & b_i[i];
      end
    end
  endgenerate 
  // Left-shift each row by i bits
  generate
    for(i = 0; i < N; i++) begin : gen_shifts
      assign shifted_row[i] = {{(N - i){1'b0}}, pp_row[i], {i{1'b0}}};
    end
  endgenerate
  
  assign sum0[0] = {2*N{1'b0}};
  
   // Accumulate partial sums over N rows
  generate
    for(i = 0; i < N; i++) begin
      assign sum0[i+1] = sum0[i] + shifted_row[i];
    end
  endgenerate
  
  
assign product_o = sum0[N];
endmodule