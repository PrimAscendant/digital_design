//basic description or
module simple_or (
	input wire in_a,
	input wire in_b,
	output wire out_c
);
  assign out_c = in_a | in_b;
endmodule

/*same moments as in mux.sv (IO names + data types)
*/