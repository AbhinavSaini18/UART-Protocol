`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 12:20:28
// Design Name: 
// Module Name: baud_gen
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


module baud_gen#(
    parameter CLK_FREQ=50000000,
    parameter BAUD_RATE=9600)
    (
    input logic clk,
    input logic reset,
    output logic baud_tick
    );
localparam CLK_PER_BIT=CLK_FREQ/BAUD_RATE;
logic [15:0]counter ;
always_ff@(posedge clk or posedge reset) begin
    if(reset) begin 
        counter<=0;
        baud_tick<=0;
    end
    else begin
        if(counter==CLK_PER_BIT-1)begin
            counter<=0;
            baud_tick<=1'b1;
        end
        else begin
            counter <= counter+1;
            baud_tick<=1'b0;
        end
    end
end
endmodule
