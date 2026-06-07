`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 12:51:55
// Design Name: 
// Module Name: uart_tx_fifo_top
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

module uart_tx_fifo_top(
    input logic clk,
    input logic reset,
    input logic baud_tick,
    input logic[7:0]cpu_data,
    input logic cpu_wr_en,
    output logic tx,
    output logic fifo_full,
    output logic fifo_empty
    );
    
logic [7:0] fifo_dout;
logic fifo_rd_en;
logic tx_busy;
logic tx_start ;
fifo tx_fifo(
    .clk(clk),
    .reset(reset),
    .wr_en(cpu_wr_en),
    .rd_en(fifo_rd_en),
    .din(cpu_data),
    .dout(fifo_dout),
    .full(fifo_full),
    .empty(fifo_empty)
    );
uart_tx tx_inst(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),

    .data_in(fifo_dout),
    .tx_start(tx_start),

    .tx(tx),
    .tx_busy(tx_busy)
    );
logic start_pending;

always_ff @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        fifo_rd_en <= 0;
        tx_start <= 0;
        start_pending <= 0;
    end
    else
    begin
        fifo_rd_en <= 0;
        tx_start <= 0;

        if(start_pending)
        begin
            tx_start <= 1;
            start_pending <= 0;
        end
        else if(!tx_busy && !fifo_empty)
        begin
            fifo_rd_en <= 1;
            start_pending <= 1;
        end
    end
end   
endmodule

