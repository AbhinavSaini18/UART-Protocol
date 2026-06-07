`timescale 1ns / 1ps

module uart_rx_fifo_top(
    input logic clk,
    input logic reset,
    input logic rx,

    input logic cpu_rd_en,

    output logic [7:0] cpu_data_out,
    output logic fifo_full,
    output logic fifo_empty,
    output logic parity_error
);

logic [7:0] rx_data;
logic rx_done;

fifo rx_fifo(
    .clk(clk),
    .reset(reset),

    .wr_en(rx_done && !fifo_full),
    .rd_en(cpu_rd_en),

    .din(rx_data),
    .dout(cpu_data_out),

    .full(fifo_full),
    .empty(fifo_empty)
);

uart_rx rx_inst(
    .clk(clk),
    .reset(reset),

    .rx(rx),

    .rx_data(rx_data),
    .rx_done(rx_done),
    .parity_error(parity_error)
);

endmodule