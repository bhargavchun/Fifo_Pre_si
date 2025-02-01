module readptr_empty#(parameter Addr_size = 9)
(
  input   rinc, r_clk, rstn,
  input   [Addr_size :0] rq2_wr_ptr,
  output reg  rempty,
  output  [Addr_size-1:0] raddr,
  output reg [Addr_size :0] r_ptr
);

  reg [Addr_size:0] rbin;
  wire [Addr_size:0] rgraynext, rbinnext;


  always_ff @(posedge r_clk or negedge rstn)
    if (rstn)begin
      rbin <= '0;
	  r_ptr <= '0;
	  end
    else begin
      rbin <= rbinnext;
	  r_ptr <= rgraynext;
	  end


  assign raddr = rbin[Addr_size-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  assign rempty_val = (rgraynext == rq2_wr_ptr);

  always_ff @(posedge r_clk or negedge rstn)
    if (rstn)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule

