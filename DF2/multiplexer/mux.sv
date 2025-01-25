//Design a 2-to-1 multiplexer (mux2to1)

module mux(
  input logic a_i, 
  input logic b_i, 
  input logic sel_i, 
  output logic y_o
  );
  assign y_o = sel_i ? b_i : a_i;
endmodule
