//------test--------

`timescale 1ns / 1ps
module tb_mux;
  reg a;
  reg b;
  reg sel;
  wire y;

  mux uut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
  );
  initial begin
    $display("Time\ta\tb\tsel\ty");
    $monitor("%g\t%b\t%b\t%b\t%b", $time, a, b, sel, y);
      
    a = 0;
    b = 0;
    sel = 0;
    
      
    #10 a = 0; b = 1; sel = 0;
    #10 a = 0; b = 1; sel = 1;
    #10 a = 1; b = 0; sel = 0;
    #10 a = 1; b = 0; sel = 1;
    #10 a = 1; b = 1; sel = 0;
    #10 a = 1; b = 1; sel = 1;
    #10 a = 0; b = 0; sel = 0;
    #10 a = 0; b = 0; sel = 1;
    
    $finish;
  end
endmodule
