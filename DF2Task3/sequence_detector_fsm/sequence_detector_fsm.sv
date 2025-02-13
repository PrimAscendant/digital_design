// 05.02
// v 0.3
// simple Sequence Detector with FSM

module fsm(
  input logic in_i,
  input logic clk, 
  input logic reset_i,
  output logic detected_o
);

  localparam [3:0] find_sequence = 4'b1011;
  
  logic [3:0] temp_sequence;


  always_ff @(posedge clk or posedge reset_i) begin
    if (reset_i) begin
      temp_sequence <= 4'b0000;
      detected_o <= 1'b0;
  end
    else begin
      temp_sequence <= {temp_sequence[2:0], in_i};
      if (temp_sequence == find_sequence) begin
        detected_o <= 1'b1;
        temp_sequence <= 4'b0000;
    end 
    else begin
        detected_o <= 1'b0;
    end
    end
  end
endmodule

