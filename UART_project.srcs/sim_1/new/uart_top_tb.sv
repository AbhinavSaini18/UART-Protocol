`timescale 1ns/1ps

module uart_top_tb;

    parameter CLK_FREQ     = 100_000_000;
    parameter BAUD_RATE    = 19200;
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    logic clk;
    logic rst;

    logic tx_start;
    logic [7:0] tx_data;
    logic tx_busy;

    logic [7:0] rx_data;
    logic rx_done;

    logic uart_line;

    // UART Transmitter
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) TX (
        .clk(clk),
        .reset(rst),
        .data_in(tx_data),
        .tx_start(tx_start),
        .tx(uart_line),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) RX (
        .clk(clk),
        .reset(rst),
        .rx(uart_line),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 100 MHz clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin

        rst      = 1;
        tx_start = 0;
        tx_data  = 8'h00;

        #100;
        rst = 0;

        // Send A5
        @(posedge clk);
        tx_data  = 8'hA5;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        // Wait for reception
        wait(rx_done);

        $display("Received Data = %h", rx_data);

        if (rx_data == 8'hA5)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        #1000;
        $finish;
    end

endmodule