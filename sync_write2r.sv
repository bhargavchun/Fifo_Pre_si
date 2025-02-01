
module sync_write2r#(parameter Addr_size = 9)
(
  input   r_clk, rstn,
  input   [Addr_size:0] w_ptr,
  output reg [Addr_size:0] rq2_wr_ptr
);

  reg [Addr_size:0] rq1_wr_ptr;

  always_ff @(posedge r_clk or negedge rstn)
    if (rstn)begin
      rq2_wr_ptr <= '0;
	  rq1_wr_ptr <= '0;
	  end
    else begin
      rq2_wr_ptr <= w_ptr;
	  rq1_wr_ptr <= w_ptr;
	  end
endmodule

