`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: tb_simple_or
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_simple_or;
    reg in_a;
    reg in_b;
    wire out_c;

  simple_or uut (
    .in_a(in_a),
    .in_b(in_b),
    .out_c(out_c)
  );
  initial begin
    $display("Time\tin_a\tin_b\tout_c");
    $monitor("%g\t%b\t%b\t%b", $time, in_a, in_b, out_c);
    //    $dumpfile("dump.vcd");
    //    $dumpvars();
      
    in_a = 0;
    in_b = 0;
    
      
    #10 in_a = 0; in_b = 0;
    #10 in_a = 0; in_b = 1;
    #10 in_a = 1; in_b = 0;
    #10 in_a = 1; in_b = 1;
    // #1
    
    #10 $finish;
  end
endmodule
