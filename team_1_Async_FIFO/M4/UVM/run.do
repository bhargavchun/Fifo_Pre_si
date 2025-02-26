vlib work
vdel -all
vlib work


vlog sync_read2w.sv
vlog sync_write2r.sv
vlog writeptr_full.sv
vlog readptr_empty.sv
vlog fifomem.sv
vlog Asynch_fifo_top.sv 
vlog fifo_uvm_tb_top.sv


vsim work.uvmtb_top


add wave -r /*
run -all
