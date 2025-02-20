
# Compile all SystemVerilog files
vlog -sv +acc fifo_pkg.sv
vlog -sv +acc sync_write2r.sv
vlog -sv +acc sync_read2w.sv
vlog -sv +acc async_fifo_tb.sv
vlog -sv +acc readptr_empty.sv
vlog -sv +acc fifomem.sv
vlog -sv +acc writeptr_full.sv
vlog -sv +acc asynch_fifo_top.sv
vlog -sv +acc scb_fifo.sv
vlog -sv +acc mon_fifo.sv
vlog -sv +acc environment.sv
vlog -sv +acc interface.sv
vlog -sv +acc test.sv
vlog -sv +acc gen_fifo.sv
vlog -sv +acc driv_fifo.sv
vlog -sv +acc trans_fifo.sv

# Run simulation, specifying a unique WLF file
vsim -wlf simulation_run.wlf work.fifo_testbench

# Add all signals to the waveform viewer
add wave -r /*

# Run the entire testbench simulation
run -all