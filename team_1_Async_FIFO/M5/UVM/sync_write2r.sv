module sync_write2r #(parameter  A_Size=8)( r_clk, r_rst,  wptr ,  wptr_sync);
input bit r_clk,r_rst;
input [A_Size:0] wptr;
output logic [A_Size:0]  wptr_sync;
logic [A_Size:0] b2sync;
  always_ff@(posedge r_clk) begin
    if(r_rst) begin
      b2sync <= 0;
      wptr_sync <= 0;
    end
    else begin
      b2sync <= wptr;
      wptr_sync <= b2sync;
    end
  end
endmodule