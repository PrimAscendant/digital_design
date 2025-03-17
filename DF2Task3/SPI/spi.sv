//`timescale 1ns / 1ps
// Revision 0.8

module spi_master (
    input logic clk,        
    input logic reset,      
    input logic start,      
    input logic [7:0] data_in,    
    input logic MISO,       

    output logic MOSI,       
    output logic SCK, // SPI clock
    output logic CS,        
    output logic [7:0] data_out,   
    output logic done        
);

  typedef enum logic [2:0] {
   IDLE  = 2'b00, // Wait
   START = 2'b01, // Start tranfer
   TRANS = 2'b10, // Transfer process
   DONE  = 2'b11 // Finish and go to the IDLE
  } state_t;

   state_t state, next_state;
   // logic [1:0] state, next_state;
   logic [7:0] shift_reg;   
  logic [2:0] bit_cnt; // Couter bit trascation
   logic sck_reg; // Register is used to generate the SCK output
   assign SCK = sck_reg;

//syn
   always_comb begin
	  case(state)
            IDLE: begin
               done <= 1'b0;
               CS <= 1'b1;
               sck_reg <= 1'b0;
               if (start) begin
                  shift_reg <= data_in;
               end
            end
           START: begin
               CS <= 1'b0;     
               bit_cnt <= 7;     
            end
            TRANS: begin
               sck_reg <= ~sck_reg;  // Toggle the internal clock line
              if (sck_reg == 1'b0) begin  // Rising edge drive MOSI
                  MOSI <= shift_reg[bit_cnt];
               end 
               else begin
                  shift_reg[bit_cnt] <= MISO;

                  if (bit_cnt == 0) begin
                     data_out <= shift_reg; // Once we have received the last bit, store it out
                  end 
                  else begin
                     bit_cnt <= bit_cnt - 1'b1; // Decrement the bit counter
                  end
               end
            end
            DONE: begin
               CS      <= 1'b1; // De-select subordinate
               sck_reg <= 1'b0;
               done    <= 1'b1;   
            end

         endcase
      end
// asyn
    always_ff @(posedge clk or negedge reset) begin
       if (~reset) begin
         state <= IDLE;
         sck_reg <= 1'b0;
         MOSI <= 1'b0;
         CS <= 1'b1; // Usually if CS = 1, "subordinate" dont select 
         bit_cnt <= 3'b0;
         shift_reg <= 8'b0;
         data_out <= 8'b0;
         done <= 1'b0;
      end 
      else begin
         state <= next_state;
            state <= IDLE;
            else begin
         state <= IDLE;
         sck_reg <= 1'b0;
         MOSI <= 1'b0;
         CS <= 1'b1;
         bit_cnt <= 3'b0;
         shift_reg <= 8'b0;
         data_out <= 8'b0;
         done <= 1'b0;
      end 
            state <= START;
            else begin
         state <= IDLE;
         sck_reg <= 1'b0;
         MOSI <= 1'b0;
         CS <= 1'b1; 
         bit_cnt <= 3'b0;
         shift_reg <= 8'b0;
         data_out <= 8'b0;
         done <= 1'b0;
      end 
            state <= TRANS;
            else begin
         state <= IDLE;
         sck_reg <= 1'b0;
         MOSI <= 1'b0;
         CS <= 1'b1;
         bit_cnt <= 3'b0;
         shift_reg <= 8'b0;
         data_out <= 8'b0;
         done <= 1'b0;
      end 
            state <= DONE;

            default: state = IDLE;
         endcase
      end
   end

   always_comb @(*) begin
      next_state = state;
      case (state)
         IDLE: if (start) next_state = START;
         START: next_state = TRANS;
         TRANS: if (bit_cnt == 0 && sck_reg == 1'b1) next_state = DONE;
        DONE: if (done) next_state = IDLE;
      endcase
   end

endmodule
