// 
// v 0.5
// simple Sequence Detector with FSM


module fsm(
 input logic in_i,
  input logic clk,
  input logic reset_i,
  output logic detected_o
);

  typedef enum logic [2:0] {
    S0, // no bits matched
    S1, // matched '1'
    S2, // matched '10'
    S3, // matched '101'
    S4  // matched '1011'
  } state_t;

  state_t state, next;

  always_comb begin
    // Default to no change
    next = state;
    case (state)
      S0: begin
        // if in == 1 then go else, defoult state
        if (in_i == 1'b1) next = S1;
        else            next = S0;
      end

      S1: begin
        if (in_i == 1'b1) next = S2;
        else            next = S1;
      end

      S2: begin
        if (in_i == 1'b1) next = S3;
        else            next = S0;
      end

      S3: begin
        if (in_i == 1'b1) next = S4;
        else            next = S2;
      end

      S4: begin
        if (in_i == 1'b1) next = S1;
        else            next = S0;
      end

      default: next = S0;
    endcase
  end


  always_ff @(posedge clk or negedge reset_i) begin
    if (reset_i) begin
      state <= S0;
      detected_o     <= 1'b0;
    end
    else begin
      state <= next;
     detected_o <= (next == S4);
    end
  end

endmodule

