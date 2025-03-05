module Asynch_fifo_top #(parameter DATASIZE = 8,parameter ADDRSIZE = 8) (intfc inf );
sync_write2r #(ADDRSIZE) w2rsync_inst(inf.r_clk,  inf.r_rst,  inf.wptr ,  inf.wptr_sync );
sync_read2w #(ADDRSIZE) r2wsync_inst(inf.w_clk, inf.w_rst, inf.rptr,  inf.rptr_sync );
writeptr_full #(ADDRSIZE) write_ptr_inst (inf.w_clk, inf.w_rst, inf.w_inc,  inf.rptr_sync,  inf.waddr, inf.wptr, inf.wfull, inf.hfull);
readptr_empty #(ADDRSIZE) read_ptr_inst (inf.r_clk, inf.r_rst, inf.r_inc,   inf.wptr_sync,  inf.raddr, inf.rptr,  inf.rempty, inf.hempty);
fifomem  #(DATASIZE,ADDRSIZE) fifo_mem_inst (inf.w_clk,inf.r_clk,inf.r_rst,inf.w_rst,inf.w_inc,inf.r_inc,inf.wfull,inf.hfull,inf.rempty,inf.hempty, inf.wdata,  inf.waddr,inf.raddr,  inf.rdata);

endmodule