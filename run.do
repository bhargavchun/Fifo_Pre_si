vlib work

vlog -source -lint readptr_empty.sv
vlog -source -lint sync_read2w.sv
vlog -source -lint sync_write2r.sv
vlog -source -lint fifomem.sv
vlog -source -lint Asynch_fifo_top.sv
vlog -source -lint writeptr_full.sv
vlog -source -lint async_fifo_tb.sv

vsim work.async_fifo_tb


run -all
