//`timescale 1ns / 1ps
// Revision 0.4

// SPI Master Module
module MOSI #(parameter N = 8)(
  // System signals
  input  logic clk,
  input  logic reset,

  // Data bus
  input  logic [N-1:0] data_in,
  output logic MOSI,

  // Control signals
  input  logic start,
  output logic SCK,
  output logic done
);

  // Calculate the width of the bit counter (log2 of N)
  localparam BIT_CNT_WIDTH = $clog2(N);

  // Internal registers
  logic [N-1:0] shift_reg;
  logic [BIT_CNT_WIDTH - 1:0] bit_cnt;

  typedef enum logic [1:0] {
    IDLE  = 2'd0,
    SHIFT = 2'd1,
    DONE  = 2'd2
  } state_t;
  
  state_t state, next_state;

  // Test version whithout generate SCK
  assign SCK = clk;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= '0;
      bit_cnt <= '0;
      MOSI <= 1'b0;
      done <= 1'b0;
    end
    else begin
      state <= next_state;  // Update FSM state

      case (state)
        IDLE: begin
          done <= 1'b0;
          if (start) begin
            // Load data to the shift register
            shift_reg <= data_in;
            bit_cnt <= '0;
          end
        end

        SHIFT: begin
          // Put the MSB of shift_reg on MOSI
          MOSI <= shift_reg[N-1];
          shift_reg <= { shift_reg[N-2:0], 1'b0 };
          // Increment bit count
          bit_cnt <= bit_cnt + 1;
        end

        DONE: begin
          // Indicate that transmission is complete
          done <= 1'b1;
        end
      endcase
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE:
        // Move to SHIFT on start
        if (start) next_state = SHIFT;

      SHIFT:
        // After sending out N bits, go to DONE
        if (bit_cnt == (N-1)) next_state = DONE;

      DONE:
        // Either stay in DONE or go back to IDLE
        next_state = IDLE;

      default: next_state = IDLE;
    endcase
  end

endmodule

