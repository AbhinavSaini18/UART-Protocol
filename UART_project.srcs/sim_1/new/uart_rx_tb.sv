`timescale 1ns / 1ps

module uart_rx_tb;

    logic clk;
    logic reset;
    logic rx;

    logic [7:0] rx_data;
    logic rx_done;

    uart_rx uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin

        // Initialize
        reset = 1;
        rx = 1;      // UART idle state

        #100;
        reset = 0;

        #100;

        // Send 0xA5 = 10100101

        // Start bit
        rx = 0;
        #104167;

        // Data bits (LSB first)
        rx = 1;   // bit0
        #104167;

        rx = 0;   // bit1
        #104167;

        rx = 1;   // bit2
        #104167;

        rx = 0;   // bit3
        #104167;

        rx = 0;   // bit4
        #104167;

        rx = 1;   // bit5
        #104167;

        rx = 0;   // bit6
        #104167;

        rx = 1;   // bit7
        #104167;

        // Stop bit
        rx = 1;
        #104167;

        // Wait for receiver
        #500000;

        $finish;

    end

endmodule