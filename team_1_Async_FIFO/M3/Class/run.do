



# Compile all SystemVerilog files with coverage enabled
vlog -cover bces -sv +acc fifo_pkg.sv
vlog -cover bces -sv +acc sync_write2r.sv
vlog -cover bces -sv +acc sync_read2w.sv
vlog -cover bces -sv +acc async_fifo_tb.sv
vlog -cover bces -sv +acc readptr_empty.sv
vlog -cover bces -sv +acc fifomem.sv
vlog -cover bces -sv +acc writeptr_full.sv
vlog -cover bces -sv +acc asynch_fifo_top.sv
vlog -cover bces -sv +acc scb_fifo.sv
vlog -cover bces -sv +acc mon_fifo.sv
vlog -cover bces -sv +acc environment.sv
vlog -cover bces -sv +acc interface.sv
vlog -cover bces -sv +acc test.sv
vlog -cover bces -sv +acc gen_fifo.sv
vlog -cover bces -sv +acc driv_fifo.sv
vlog -cover bces -sv +acc trans_fifo.sv
vlog -cover bces -sv +acc fifo_coverage.sv

# Optimize testbench with full coverage tracking
vopt testbench -o fifo_testbench_Opt +acc +cover=sbfec

# Run simulation with coverage tracking and specify an alternate waveform file
vsim -wlf coverage_run.wlf -coverage fifo_testbench_Opt

# Add all signals to the waveform viewer
add wave -r /*

# Run the entire testbench simulation
run -all

# Generate a detailed coverage report
coverage report -detail -output coverage_results.txt

coverage report -detail

