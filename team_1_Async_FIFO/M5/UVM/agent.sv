class agent extends uvm_agent;
	`uvm_component_utils(agent) 
	sequencer  seq;
	driver driv;
	monitor mon;


	function new(string name ="agent",uvm_component parent);
		super.new(name,parent);
		`uvm_info("you are in agent class", "Inside new!!",UVM_LOW)

	endfunction
	
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("you are in agent class", "Inside build phase!!",UVM_LOW)
                seq = sequencer::type_id::create("seq",this);
		driv = driver::type_id::create("driv",this);
		mon = monitor:: type_id::create("mon", this);
	endfunction
	
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("you are in agent class", "Inside connect phase!!",UVM_LOW)
                 driv.seq_item_port.connect(seq.seq_item_export);
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("you are in agent class", "Inside run phase!!",UVM_LOW)
	endtask
	
endclass