module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input logic clk,
    input logic reset,

    input logic wr_en,
    input logic rd_en,

    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,

    output logic full,
    output logic empty
);
logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
localparam ADDR_WIDTH = $clog2(DEPTH);

logic [ADDR_WIDTH-1:0] wr_ptr;
logic [ADDR_WIDTH-1:0] rd_ptr;

logic [ADDR_WIDTH:0] count;
assign empty = (count == 0);
assign full  = (count == DEPTH);


always_ff @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        wr_ptr <= '0;
        rd_ptr <= '0;
        count  <= '0;
        dout   <= '0;
    end
    else
    begin
         if (wr_en && !rd_en && !full)
            begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
         else if (rd_en && !wr_en && !empty)
            begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end 
          else if (wr_en && rd_en && !full && !empty)
            begin
                mem[wr_ptr] <= din;
                dout <= mem[rd_ptr];
            
                wr_ptr <= wr_ptr + 1;
                rd_ptr <= rd_ptr + 1;
            
                // count unchanged
            end 

    end
end
endmodule