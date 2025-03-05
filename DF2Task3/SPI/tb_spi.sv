// Testbench
module spi_master_test;
  
  logic clk;       
  logic reset;      
  logic start;      
  logic [7:0] data_in;    
  logic MISO; 
  
  logic MOSI;     
  logic SCK; // SPI clock
  logic CS;       
  logic [7:0] data_out;  
  logic done;

// Instantiate design under test
 spi_master DFF(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .MISO(MISO),
    .MOSI(MOSI),
    .SCK(SCK),
    .CS(CS),
    .data_out(data_out),
    .done(done)
 );
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  
 initial begin
 $dumpfile("dump.vcd"); $dumpvars;
 $dumpvars(1);
   #10;
    reset = '1;
    start = '0;
    data_in = 8'b00000000; 
    MISO = '0;
   
    #10;
    @(posedge clk);
    // start transfer
    reset = '0;
    start = '1;
    data_in = 8'b11111111; 
    MISO = '1;
    #10;

   for(int i=0; i < 18; i++)begin
       @(posedge clk);
   #10;
     end
  
    @(posedge clk);
    // check reset
    reset = '1;
    start = '1;
    data_in = 8'b11011011;
    MISO = '0;
    #10;
     
  $finish; 
 end
endmodule
