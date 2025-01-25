// 4-to-1 Multiplexer

module four_to_one_mux(
  input logic a_i, b_i, c_i, d_i,
  input logic [1:0] sel_i,
  output logic y_o
);
  
    always_comb begin
        case(sel_i)
            2'b00: y_o = a_i;
            2'b01: y_o = b_i;
            2'b10: y_o = c_i;
            2'b11: y_o = d_i;
        endcase
    end
endmodule
