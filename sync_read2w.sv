module sync_read2w #(parameter Addr_size = 9)
 (
  input   w_clk, wrst_n,
  input   [Addr_size:0] r_ptr,
  output reg  [Addr_size:0] wq2_rptr
);

  reg [Addr_size:0] wq1_r_ptr;

  always_ff @(posedge w_clk or negedge wrst_n)
    if (wrst_n) begin
	wq2_rptr <= 0;
	wq1_r_ptr <= '0;
	end
    else begin
	wq2_rptr <= wq1_r_ptr;
	wq1_r_ptr <= r_ptr;
	end
endmodule
