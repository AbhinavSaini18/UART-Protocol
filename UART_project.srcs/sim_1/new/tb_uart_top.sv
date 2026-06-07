`timescale 1ns / 1ps

module tb_uart_top;

logic clk;
logic reset;

logic rx;
logic tx;

logic [7:0] tx_data;
logic tx_wr_en;

logic rx_rd_en;
logic [7:0] rx_data;

logic tx_fifo_full;
logic tx_fifo_empty;

logic rx_fifo_full;
logic rx_fifo_empty;

logic parity_error;


// DUT
uart_top dut(
    .clk(clk),
    .reset(reset),

    .rx(rx),
    .tx(tx),

    .tx_data(tx_data),
    .tx_wr_en(tx_wr_en),

    .rx_rd_en(rx_rd_en),
    .rx_data(rx_data),

    .tx_fifo_full(tx_fifo_full),
    .tx_fifo_empty(tx_fifo_empty),

    .rx_fifo_full(rx_fifo_full),
    .rx_fifo_empty(rx_fifo_empty),

    .parity_error(parity_error)
);


// 50 MHz Clock
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end


// Loopback Connection
always_comb begin
    rx = tx;
end


initial begin

    // Reset
    reset = 1;
    tx_wr_en = 0;
    rx_rd_en = 0;
    tx_data = 8'h00;

    #100;

    reset = 0;

    //----------------------------------
    // Send A
    //----------------------------------
    @(posedge clk);
    tx_data  = 8'h41;
    tx_wr_en = 1;

    @(posedge clk);
    tx_wr_en = 0;

    //----------------------------------
    // Send B
    //----------------------------------
    @(posedge clk);
    tx_data  = 8'h42;
    tx_wr_en = 1;

    @(posedge clk);
    tx_wr_en = 0;

    //----------------------------------
    // Send C
    //----------------------------------
    @(posedge clk);
    tx_data  = 8'h43;
    tx_wr_en = 1;

    @(posedge clk);
    tx_wr_en = 0;

    //----------------------------------
    // Wait for transmission/reception
    //----------------------------------
    #4000000;

    //----------------------------------
    // Read RX FIFO
    //----------------------------------

    repeat(3)
    begin

        @(posedge clk);
        rx_rd_en = 1;

        @(posedge clk);
        rx_rd_en = 0;

        @(posedge clk);

        $display("Received = %h (%c)", rx_data, rx_data);

    end

    #1000;

    $finish;

end

endmodule