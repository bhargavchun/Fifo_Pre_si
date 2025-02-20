

interface intfc(input bit w_clk, r_clk, w_rst, r_rst);

parameter DATASIZE = 8;parameter ADDRSIZE = 9;

parameter w_clk_width=2; 
parameter r_clk_width=4; 
logic w_inc, r_inc;
logic [ADDRSIZE:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit wfull, rempty;
logic [DATASIZE-1:0] wdata,rdata;

modport driver ( input w_clk,r_clk, w_rst, r_rst);
modport monitor( input w_clk,r_clk, w_rst, r_rst);

endinterface