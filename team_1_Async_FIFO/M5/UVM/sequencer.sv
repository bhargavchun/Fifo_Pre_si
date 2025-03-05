import uvm_pkg::*;
`include "uvm_macros.svh"

class sequencer extends uvm_sequencer #(fifo_seq_item);
	`uvm_component_utils(sequencer) 
	
	function new (string name ="sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("You are in Sequencer Class", "Inside New!!",UVM_LOW)
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("You are in Sequencer Class", "Inside Build_phase!!",UVM_LOW)
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("You are in Sequencer Class", "Inside Connect_phase!!",UVM_LOW)
	endfunction

endclass