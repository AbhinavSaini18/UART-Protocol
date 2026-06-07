`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 16:15:09
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: UART Receiver with 2-FF Synchronizer
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_rx #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600,
    parameter PARITY_EN = 1,
    parameter ODD_PARITY = 0
)(
    input  logic clk,
    input  logic reset,

    input  logic rx,

    output logic [7:0] rx_data,
    output logic rx_done,
    output logic parity_error
);

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

typedef enum logic [2:0] {
    IDLE,
    START,
    DATA,
    PARITY,
    STOP,
    CLEANUP
} state_t;

state_t state;

logic [12:0] baud_counter;
logic [2:0]  bit_index;

logic parity_received;
logic [7:0] data_reg;


logic rx_sync1, rx_sync2;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        rx_sync1 <= 1'b1;
        rx_sync2 <= 1'b1;
    end
    else begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end
end



always_ff @(posedge clk or posedge reset) begin

    if (reset) begin
   
        data_reg <= 8'b0;
        rx_data <= 8'b0;
        rx_done <= 1'b0;
        baud_counter <= 0;
        bit_index <= 0;
        parity_error <= 1'b0;
        parity_received <= 1'b0;
        state <= IDLE;
    end

    else begin

        case(state)

            IDLE: begin
                rx_done <= 0;
                baud_counter <= 0;
                bit_index <= 0;
                parity_error <= 0;

                if (rx_sync2 == 1'b0)
                    state <= START;
            end

      

            START: begin

                // Sample at middle of start bit
                if (baud_counter == (CLKS_PER_BIT-1)/2) begin
                    baud_counter <= 0;

                    // Confirm still LOW
                    if (rx_sync2 == 1'b0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end

                else
                    baud_counter <= baud_counter + 1;

            end


            DATA: begin

                if (baud_counter < CLKS_PER_BIT-1)
                    baud_counter <= baud_counter + 1;

                else begin

                    baud_counter <= 0;

                    // UART sends LSB first
                    data_reg[bit_index] <= rx_sync2;

                    if (bit_index < 7)
                        bit_index <= bit_index + 1;

                    else begin
                        bit_index <= 0;
                    
                        if(PARITY_EN)
                            state <= PARITY;
                        else
                            state <= STOP;
                    end 
                end
            end
            PARITY: begin
    
                if (baud_counter < CLKS_PER_BIT-1)
                    baud_counter <= baud_counter + 1;
            
                else begin
            
                    baud_counter <= 0;
            
                    parity_received <= rx_sync2;
            
                    state <= STOP;
            
                end
            
            end 



           STOP: begin
    
                    if (baud_counter < CLKS_PER_BIT-1)
                        baud_counter <= baud_counter + 1;
                
                    else begin
                
                        baud_counter <= 0;
                
                        if(PARITY_EN) begin
                
                            if(ODD_PARITY)
                                parity_error <= (parity_received != ~(^data_reg));
                            else
                                parity_error <= (parity_received != ^data_reg);
                
                        end
                        else
                            parity_error <= 0;
                
                        // Accept data only if stop bit is valid
                        // AND parity is correct
                
                        if (rx_sync2 == 1'b1) begin
                
                            if (!PARITY_EN ||
                               (ODD_PARITY  && (parity_received == ~(^data_reg))) ||
                               (!ODD_PARITY && (parity_received ==  ^data_reg))) begin
                
                                rx_data <= data_reg;
                                rx_done <= 1'b1;
                
                            end
                        end
                
                        state <= CLEANUP;
                    end
                end 
            CLEANUP: begin
                rx_done <= 1'b0;
                state <= IDLE;
            end

        endcase
    end
end

endmodule