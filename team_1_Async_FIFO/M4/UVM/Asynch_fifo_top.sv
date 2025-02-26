
module Asynch_fifo_top #(parameter DATASIZE = 8,parameter ADDRSIZE = 9) (intfc inf);
sync_write2r #(ADDRSIZE) sync_write2r_inst(inf.r_clk,  inf.r_rst,  inf.wptr ,  inf.wptr_sync );
sync_read2w #(ADDRSIZE) sync_read2w_inst(inf.w_clk, inf.w_rst, inf.rptr,  inf.rptr_sync );


writeptr_full #(ADDRSIZE) writeptr_full_inst (inf.w_clk, inf.w_rst, inf.w_inc,  inf.rptr_sync,  inf.waddr, inf.wptr, inf.wfull);


readptr_empty #(ADDRSIZE) readptr_empty_inst (inf.r_clk, inf.r_rst, inf.r_inc,   inf.wptr_sync,  inf.raddr, inf.rptr,  inf.rempty);


fifomem #(DATASIZE,ADDRSIZE) fifo_mem_inst (inf.w_clk,inf.r_clk,inf.r_rst,inf.w_rst,inf.w_inc,inf.r_inc,inf.wfull,inf.rempty, inf.wdata,  inf.waddr,inf.raddr,  inf.rdata);

endmodule