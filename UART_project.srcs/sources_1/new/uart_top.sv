`timescale 1ns / 1ps

module uart_top(
    input  logic clk,
    input  logic reset,

    // UART Pins
    input  logic rx,
    output logic tx,

    // TX Interface (CPU -> UART)
    input  logic [7:0] tx_data,
    input  logic tx_wr_en,

    // RX Interface (UART -> CPU)
    input  logic rx_rd_en,
    output logic [7:0] rx_data,

    // TX FIFO Status
    output logic tx_fifo_full,
    output logic tx_fifo_empty,

    // RX FIFO Status
    output logic rx_fifo_full,
    output logic rx_fifo_empty,

    // Error Status
    output logic parity_error
);

logic baud_tick;

// Baud Rate Generator
baud_gen baud_inst(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

// TX Path
uart_tx_fifo_top tx_path(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),

    .cpu_data(tx_data),
    .cpu_wr_en(tx_wr_en),

    .tx(tx),

    .fifo_full(tx_fifo_full),
    .fifo_empty(tx_fifo_empty)
);

// RX Path
uart_rx_fifo_top rx_path(
    .clk(clk),
    .reset(reset),

    .rx(rx),

    .cpu_rd_en(rx_rd_en),
    .cpu_data_out(rx_data),

    .fifo_full(rx_fifo_full),
    .fifo_empty(rx_fifo_empty),

    .parity_error(parity_error)
);

endmodule