vlog sync_write2r.sv	+acc
vlog sync_read2w.sv	+acc
vlog writeptr_full.sv	+acc
vlog readptr_empty.sv	+acc
vlog fifomem.sv	+acc
vlog Asynch_fifo_top.sv 	+acc
vlog fifo_uvm_tb_top.sv

vsim -coverage -vopt work.fifo_uvm_tb_top

add wave -r /*
run -all

vcover report -html uvm_fifo_coverage
coverage report -detail

