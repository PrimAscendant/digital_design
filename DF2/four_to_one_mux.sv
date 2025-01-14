/*same moments as in mux.sv (IO names + data types)
*/
module four_to_one_mux(
  input wire a, b, c, d,
  input wire [1:0] sel,
  output reg y
);

 // You could even use always_comb 
    always @(*) begin
        case(sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
        endcase
    end
endmodule
