// Testbench
module test;
    logic in_i;
    logic clk;
    logic reset_i;
    logic detected_o;

  // Instantiate design under test
    fsm dut (
        .in_i      (in_i),
        .clk       (clk),
        .reset_i   (reset_i),
        .detected_o(detected_o)
    );

    initial clk = 0;
    always #10 clk = ~clk;


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);

        #25
        reset_i = 0;  
        in_i = 1; 
        #20;
        in_i = 0; 
        #20;
        
        in_i = 1; 
        #20;
        in_i = 1;
      // detected_o should be 1
        #50
        reset_i = 1; 
        
      
        in_i = 1; 
        #20;
        in_i = 0; 
        #20;
        
        in_i = 1; 
        #20;
        in_i = 1; 
      
      // other
        #20;
        in_i = 1; 
        #20;
        in_i = 1; 
        #20; 
        
        in_i = 0; 
        #20;
        in_i = 1; 
        #50;



        $finish;
    end
endmodule

