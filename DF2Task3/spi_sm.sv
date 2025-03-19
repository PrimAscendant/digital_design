//`timescale 1ns / 1ps
// Revision 0.3

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

  typedef enum logic [2:0] {
   IDLE  = 2'b00, // Wait
   START = 2'b01, // Start tranfer
   TRANS = 2'b10, // Transfer process
   DONE  = 2'b11 // Finish and go to the IDLE
  } state_t;

   state_t state, next_state;

  logic [N-1:0] shift_reg;
  logic [2:0] bit_cnt;

  // A multi-flop synchronizer
  logic sck_d1, sck_d2;
  logic mosi_d1, mosi_d2;
  logic cs_d1,  cs_d2;

  always_ff @(posedge clk or negedge reset) begin
    if (~reset) begin
      sck_d1 <= 1'b0;
      sck_d2 <= 1'b0;
      mosi_d1 <= 1'b0;
      mosi_d2 <= 1'b0;
      cs_d1 <= 1'b1;
      cs_d2 <= 1'b1;
    end
    else begin
      sck_d1 <= SCK;
      sck_d2 <= sck_d1;
      mosi_d1 <= MOSI;
      mosi_d2 <= mosi_d1;
      cs_d1 <= CS;
      cs_d2 <= cs_d1;
    end
  end

  // Synchro
  logic sck_sync = sck_d2;
  logic mosi_sync = mosi_d2;
  logic cs_sync = cs_d2;

  logic sck_rising = (sck_d2 && ~sck_d1); 

  //syn
  always_ff @(posedge clk or negedge reset) begin
    if (~reset) begin
      state <= IDLE;
      shift_reg <= 8'b0;
      data_out <= 8'b0;
      bit_cnt <= 3'b0;
      done <= 1'b0;
    end
    else begin
      state <= next_state;
      case (state)
        IDLE: begin
          done <= 1'b0;
          if (start && ~cs_sync) begin
            shift_reg <= 8'b0;
            bit_cnt <= N-1;
          end
        end
        START: begin
          done <= 1'b0;
        end
        TRANS: begin
          if (sck_rising) begin
            shift_reg[bit_cnt] <= mosi_sync;
            if (bit_cnt == 0) begin
              data_out <= shift_reg;
            end
            else begin
              bit_cnt <= bit_cnt - 1'b1; // Decrement the bit counter
            end
          end
          done <= 1'b0;
        end
        DONE: begin
          done <= 1'b1;
        end
      endcase
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: if (start && ~cs_sync) next_state = START;
      START: next_state = TRANS;
      TRANS: if ((bit_cnt == 0) && sck_rising) next_state = DONE;
      DONE: if (cs_sync) next_state = IDLE;
    endcase
  end

endmodule


