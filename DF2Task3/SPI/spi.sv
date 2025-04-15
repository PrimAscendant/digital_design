`timescale 1ns / 1ps
// Revision 1.1

module spi_master (
    input logic             clk,        
    input logic           reset,      
    input logic           start,      
    input logic   [7:0] data_in,    
    input logic            MISO,       

    output logic           MOSI,       
    output logic            SCK, // SPI clock
    output logic             CS,        
    output logic [7:0] data_out,   
    output logic           done        
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00, // Wait
        START = 2'b01, // Start tranfer
        TRANS = 2'b10, // Transfer process
        DONE  = 2'b11  // Finish and go to the IDLE
    } state_t;

    state_t state, next_state;
    logic [7:0]    shift_reg;
    logic [2:0]      bit_cnt; // Couter bit trascation
    logic            sck_reg; // Register is used to generate the SCK output
    
    assign SCK = sck_reg;

    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin
            state        <= IDLE;
            sck_reg      <= 1'b0;
            shift_reg    <= 8'b0;
            bit_cnt      <= 3'b0;
        end
         else begin
            state <= next_state;
            case (next_state)
                START: begin   // Initialize for transfer
                    shift_reg <= data_in;
                    bit_cnt         <= 7; // Set bit counet to 7
                    sck_reg      <= 1'b0; 
                end
                TRANS: begin
                    sck_reg <= ~sck_reg;
                    if (sck_reg == 1'b1) begin  // When sck_reg transitions to 1 (rises), shift in the MISO bit
                        shift_reg <= {shift_reg[6:0], MISO}; // move 7 bits (from most significant) in each rising edge sck_reg
                        bit_cnt <= bit_cnt - 1'b1;  // Decrement bit counter
                    end
                end
                DONE: begin
                    sck_reg <= 1'b0;
                end
                default: begin
                    sck_reg      <= 1'b0;
                    shift_reg    <= 8'b0;
                    bit_cnt      <= 3'd0;
                end
            endcase
        end
    end
    always_comb begin 
        case(state)
            IDLE: begin
                done     = 1'b0;
                CS       = 1'b1; // Usually if CS = 1, "subordinate" dont select 
                MOSI     = 1'b0;
                data_out = 8'b0;
            end
            START: begin
                CS = 1'b0;         
            end
            TRANS: begin
                CS = 1'b0;
                if (sck_reg == 1'b0) begin
                    MOSI = shift_reg[bit_cnt]; // On the falling edge of sck_reg drive 1 bit
                end
            end
            DONE: begin
                CS = 1'b1; // De-select subordinate
                data_out = shift_reg;
                done = 1'b1;   
            end
            default: begin
                done = 1'b0;
                CS   = 1'b1;
                MOSI = 1'b0;
            end
        endcase
    end
    always_comb begin
        next_state = state;
        case (state)
            IDLE:   next_state = (start) ? START : IDLE;
            START:  next_state = TRANS;
            TRANS: next_state = (bit_cnt == 0 && sck_reg == 1'b1) ? DONE : TRANS;
            DONE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule 
