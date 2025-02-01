
module writeptr_full#(parameter Addr_size = 9)
(
  input   w_inc, w_clk, wrst_n,
  input   [Addr_size :0] wq2_rptr,
  output reg  w_full,
  output  [Addr_size-1:0] waddr,
  output reg [Addr_size :0] w_ptr
);

   reg [Addr_size:0] wbin;
  wire [Addr_size:0] wgraynext, wbinnext;

  always_ff @(posedge w_clk or negedge wrst_n)
    if (wrst_n)begin
      wbin <= '0;
	  w_ptr	<= '0;
	  end
    else begin
      wbin  <= wbinnext;
	  w_ptr  <= wgraynext;
	  end

  assign waddr = wbin[Addr_size-1:0];
  assign wbinnext = wbin + (w_inc & ~w_full);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  assign w_full_val = (wgraynext=={~wq2_rptr[Addr_size:Addr_size-1], wq2_rptr[Addr_size-2:0]});

  always_ff @(posedge w_clk or negedge wrst_n)
    if (wrst_n)
      w_full <= 1'b0;
    else
      w_full <= w_full_val;

endmodule