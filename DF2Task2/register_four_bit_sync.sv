/*
This code represents a 4-Bit Register with Synchronous Reset and Enable.
When reset is active, Q should reset to 0. When enable is active,
Q should take the value of D on the rising edge of clk.
*/
//

// paranter N = number of bits
module four_bit_reg_syn #(parameter N = 4)(
  input logic clk, 
  input logic reset_i, 
  input logic enable_i,
  input logic [N-1:0] d_i, 
  output logic [N-1:0] q_o
);

  always_ff @(posedge clk)begin
    if (reset_i)begin
      q_o <= N'b0000;
    end
    else if(enable_i)begin
      q_o <= d_i;
    end
  end 
endmodule 
