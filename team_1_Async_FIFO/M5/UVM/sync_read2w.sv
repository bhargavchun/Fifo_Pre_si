module sync_read2w #(parameter A_Size=8)( w_clk, w_rst, rptr,  rptr_sync);
input bit w_clk, w_rst;
input logic [A_Size:0]  rptr;
output logic [A_Size:0]rptr_sync;
logic [A_Size:0] b1sync;
  always_ff@(posedge w_clk) begin
    if(w_rst) begin
      b1sync <= 0;
      rptr_sync <= 0;
    end
    else begin
      b1sync <= rptr;
      rptr_sync <= b1sync;
    end
  end
endmodule