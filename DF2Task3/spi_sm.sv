`timescale 1ns / 1ps
// Revision 0.4

// SPI Slave Module
module SPI_Slave #(parameter N = 8)(
  input logic clk,
  input logic reset, // Reset, active low
  input logic start,
  input logic MOSI,
  input logic SCK,
  input logic CS,

  output logic [N-1:0] data_out, 
  output logic done
);

  typedef enum logic [1:0] {
   IDLE  = 2'b00, // Wait
   START = 2'b01, // Start transfer
   TRANS = 2'b10, // Transfer process
   DONE  = 2'b11 // Finish and go to the IDLE
  } state_t;

  state_t state, next_state;

  logic [N-1:0] shift_reg;
  logic [2:0] bit_cnt;

  // A multi-flop synchronizer
  logic sck_d1, sck_d2;
  logic mosi_d1, mosi_d2;
  logic cs_d1, cs_d2;

  logic sck_sync, mosi_sync, cs_sync;
  logic sck_rising;

  // Synchronizer logic
  always_ff @(posedge clk or negedge reset) begin
    if (~reset) begin
      sck_d1 <= 1'b0;
      sck_d2 <= 1'b0;
      mosi_d1 <= 1'b0;
      mosi_d2 <= 1'b0;
      cs_d1 <= 1'b1;
      cs_d2 <= 1'b1;
    end else begin
      sck_d1 <= SCK;
      sck_d2 <= sck_d1;
      mosi_d1 <= MOSI;
      mosi_d2 <= mosi_d1;
      cs_d1 <= CS;
      cs_d2 <= cs_d1;
    end
  end

  assign sck_sync = sck_d2;
  assign mosi_sync = mosi_d2;
  assign cs_sync = cs_d2;
  assign sck_rising = (sck_d2 && ~sck_d1); 

  always_ff @(posedge clk or negedge reset) begin
    if (~reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
      case (next_state)
        IDLE: begin
           shift_reg <= 8'b0;
           bit_cnt <= 3'b0;
           done <= 1'b0;
           data_out <= 8'b0;
        end
        START: begin
          bit_cnt <= N-1; // Set bit counter to 7
        end
        TRANS: begin
          if (sck_rising) begin
            shift_reg <= {shift_reg[6:0], mosi_sync};
            bit_cnt <= bit_cnt - 1'b1;  // Decrement bit counter
            if (bit_cnt == 0) begin
              data_out <= {shift_reg[6:0], mosi_sync}; // Output data
            end
          end
        end
        DONE: begin
          done <= 1'b1;
        end
        default: begin
          shift_reg <= 8'b0;
          bit_cnt <= 3'b0;
          done <= 1'b0;
        end
      endcase
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: next_state = (start && ~cs_sync) ? START : IDLE;
      START: next_state = TRANS;
      TRANS: next_state = (bit_cnt == 0 && sck_rising) ? DONE : TRANS; // Stay in TRANS until done
      DONE: next_state = (cs_sync) ? IDLE : DONE;
      default: next_state = IDLE;
    endcase
  end
endmodule