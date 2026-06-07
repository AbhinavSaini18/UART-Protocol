`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 11:05:07
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb;
logic clk;
logic reset;
logic wr_en;
logic rd_en;
logic [7:0]din;
logic [7:0]dout;
logic full;
logic empty;
fifo uut(
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty));
always #5 clk = ~clk;
initial begin

    clk = 0;
    reset = 1;

    wr_en = 0;
    rd_en = 0;
    din = 0;

    #20;
    reset = 0;
    #10;
    
    din = 8'h55;
    wr_en = 1;
    #10;
    
    din = 8'hAA;
    #10;
    
    din = 8'hF0;
    #10;
    
    wr_en = 0;
    
    #20;
    
    rd_en = 1;
    #10;
    
    #10;
    
    #10;
    
    rd_en = 0;
end
always @(posedge clk)
begin
    if(rd_en && !empty)
        $display("Time=%0t Data=%h", $time, dout);
end
endmodule
