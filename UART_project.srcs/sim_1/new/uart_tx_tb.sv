`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2026 12:39:30
// Design Name: 
// Module Name: uart_tx_tb
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


module uart_tx_tb;

    logic clk;
    logic reset;

    logic [7:0] data_in;
    logic tx_start;

    logic tx;
    logic tx_busy;
    uart_tx uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );
     initial clk = 0;
     always #10 clk = ~clk;
     initial begin

    // Initialize signals
    reset = 1;
    data_in = 8'h00;
    tx_start = 0;

    // Hold reset for some time
    #100;
    reset = 0;

    // Wait a little
    #100;

    // Send byte
    data_in = 8'hA5;
    tx_start = 1;

    // Keep tx_start high for 1 clock cycle
    #20;
    tx_start = 0;

    // Wait long enough for transmission to finish
    #2000000;

    $finish;

end

endmodule