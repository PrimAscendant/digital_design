//`timescale 1ns / 1ps
// Revision 0.2

// SPI Slave Module
module SPI_Slave #(parameter N = 8)(
  // System signals
  input  logic clk,
  input  logic reset,

  // SPI signals
  input  logic MOSI,
  input  logic SCK,

  // Control signal
  input  logic start,

  // Output data bus
  output logic [N-1:0] data_out,

  // Status
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

  // Sample and shift data on the rising edge of SCK
  always_ff @(posedge SCK or posedge reset) begin
    if (reset) begin
      state      <= IDLE;
      shift_reg  <= '0;
      bit_cnt    <= '0;
      done       <= 1'b0;
    end
    else begin
      state <= next_state;  // Update FSM state

      case (state)
        IDLE: begin
          done <= 1'b0;
          if (start) begin
            bit_cnt <= '0;
          end
        end

        SHIFT: begin
          // Shift in the bit from MOSI
          shift_reg <= { shift_reg[N-2:0], MOSI };
          bit_cnt   <= bit_cnt + 1;
        end

        DONE: begin
          // Indicate that reception is complete
          done <= 1'b1;
        end
      endcase
    end
  end

  // Next-state logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE:
        // Move to SHIFT on start
        if (start) next_state = SHIFT;

      SHIFT:
        // After receiving N bits, go to DONE
        if (bit_cnt == (N-1)) next_state = DONE;

      DONE:
        // Either stay in DONE or go back to IDLE
        next_state = IDLE;

      default: next_state = IDLE;
    endcase
  end

  // Provide the received data on data_out
  assign data_out = shift_reg;

endmodule

