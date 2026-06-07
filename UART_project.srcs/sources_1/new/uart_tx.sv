`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 09:51:52
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(
    parameter CLK_FREQ=50000000,
    parameter BAUD_RATE=9600,
    parameter PARITY_EN = 1,
    parameter ODD_PARITY = 0
)(
    input logic clk,
    input logic reset,
    input logic baud_tick,
    
    input logic [7:0] data_in,
    input logic tx_start,
    
    output logic tx,
    output logic tx_busy

    );

    
    typedef enum logic[2:0]{
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    }state_t;
    state_t state;
    
    
    logic [2:0]bit_index;    //index of bit currently being transmitted
    logic [7:0]data_reg; //stores the byte being transmitted
    logic parity_bit;
    
    //FSM
    always_ff @(posedge clk or posedge reset)begin
        if (reset)begin
            state<=IDLE;
            tx<=1'b1;
            tx_busy<=1'b0;
            bit_index<=0;
            data_reg<=0;
            parity_bit <= 1'b0;
        end
            
        else begin
            case(state)
                IDLE:begin
                    tx<=1'b1;
                    tx_busy<=1'b0;
                    bit_index<=0;
                    if(tx_start) begin
                        data_reg <= data_in;
                    
                        if(ODD_PARITY)
                            parity_bit <= ~(^data_in);
                        else
                            parity_bit <= ^data_in;
                    
                        tx_busy <= 1'b1;
                        state <= START;
                    end 
                     end
                 START:begin
                       tx<=1'b0;
                       if(baud_tick)
                            state <= DATA;
                 end
                 DATA:begin
                        tx <= data_reg[bit_index];
                    
                        if(baud_tick) begin
                        
                            if(bit_index < 7)
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
            
                    tx <= parity_bit;
                
                    if(baud_tick)
                        state <= STOP;
                
                end 
                 STOP:begin
                       tx<=1'b1;
                        if(baud_tick) begin
                            tx_busy <= 1'b0;
                            state <= IDLE;
                        end 
                  end
        endcase
    end
end

endmodule

                 

