
module async_fifo#( parameter DSIZE = 8, parameter ASIZE = 9)
(
  input   w_inc, w_clk, wrst_n,
  input   rinc, r_clk, rstn,
  input   [DSIZE-1:0] wdata,

  output  [DSIZE-1:0] rdata,
  output  w_full,
  output  rempty
);

  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] w_ptr, r_ptr, wq2_rptr, rq2_wr_ptr;

  sync_read2w sync_r2w (.*);
  sync_write2r sync_w2r (.*);
  fifomem #(DSIZE, ASIZE) fifomem (.*);
  readptr_empty #(ASIZE) rptr_empty (.*);
  writeptr_full #(ASIZE) wptr_full (.*);

endmodule
