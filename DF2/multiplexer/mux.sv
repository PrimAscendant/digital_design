module mux(
  input wire a, 
  input wire b, 
  input wire sel, 
  output wire y
  );
  assign y = sel ? b : a;
endmodule
/*
Everything is ok
1)Just a small comment regarding inputs and outputs
write them with _i and _o. In that way its much more easier to analyze the code:
Example a_i, b_i, y_o
2) If you use systemverilog then better to use "logic" type instead of "wire"
*/