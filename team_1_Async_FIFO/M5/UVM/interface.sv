interface intfc(input bit w_clk, r_clk, w_rst, r_rst);
parameter  DATASIZE=8, ADDRSIZE=8;
parameter wclk_width=4;
parameter rclk_width=10;
logic w_inc, r_inc;
logic [ADDRSIZE:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit wfull, rempty, hfull, hempty;
logic [DATASIZE-1:0] wdata,rdata;
logic  [DATASIZE-1:0] wdata_q[$],rdata_q;
		
endinterface
