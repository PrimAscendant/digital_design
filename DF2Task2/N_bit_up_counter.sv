// 3-bit up-counter with reset and enable

module NBitUpCounter #(parameter FA_BIT_WIDTH = 3)(
  input logic clk,
  input logic reset_i,
  input logic enable_i,
  output [FA_BIT_WIDTH-1:0] cout_o
);    
  always_ff @(posedge clk or posedge reset_i) begin
    if(reset_i)begin
      cout_o <= '0;
      end
    else begin
        if (enable_i) begin
          cout_o <= cout_o + 1'b1;
        end
    end
  end
endmodule

      
