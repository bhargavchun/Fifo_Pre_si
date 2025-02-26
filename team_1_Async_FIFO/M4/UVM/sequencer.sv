import uvm_pkg::*;
`include "uvm_macros.svh"

class sequencer extends uvm_sequencer #(fifo_seq_item);
	`uvm_component_utils(sequencer) 
	
	function new (string name ="sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("you are in sequencer class", "Inside new!!",UVM_LOW)
	endfunction 
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("you are in sequencer class", "Inside build phase!!",UVM_LOW)
	endfunction
	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("you are in sequencer class", "Inside connect phase!!",UVM_LOW)
        endfunction

endclass