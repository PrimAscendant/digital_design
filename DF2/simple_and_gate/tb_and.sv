`timescale 1ns / 1ps
//------test--------


module tb_and;
  reg in_a;
  reg in_b;
  wire out_c;

  simple_and uut (
    .in_a(in_a),
    .in_b(in_b),
    .out_c(out_c)
  );
  
  initial begin
    // Dump waves
    // $dumpfile("dump.vcd");
    // $dumpvars(1);
  
  
    $display("Time\tin_a\tin_b\tout_c");
    $monitor("%g\t%b\t%b\t%b", $time, in_a, in_b, out_c);
      
    in_a = 0;
    in_b = 0;
    
    
    #10 in_a = 0; in_b = 1;
    #10 in_a = 1; in_b = 0;
    #10 in_a = 1; in_b = 1;
    #10 in_a = 0; in_b = 0;

    $finish;
  end
endmodule