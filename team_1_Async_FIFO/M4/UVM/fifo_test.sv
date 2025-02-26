
class uvmtest extends uvm_test;
	`uvm_component_utils(uvmtest)
	
	fifo_env env; 
	fifo_sequence    seq_rst;
	fifo_sequence_wr seq_wr; 
        
	sequence_fifo_rd seq_rd;
	function new(string name ="uvmtest",uvm_component parent);
		super.new(name,parent);
		`uvm_info("you are in uvm test class", "Inside new!!",UVM_LOW)
	endfunction
	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("you are in uvm test class", "Inside build Phase!!",UVM_LOW)
		env = fifo_env::type_id::create("env",this);
	endfunction
	
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("you are in uvm test class", "Inside connect phase!!",UVM_LOW)
	endfunction

	
      task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("you are in uvm test class", "Inside run phase!!",UVM_LOW)
		phase.raise_objection(this);
		
			seq_rst=fifo_sequence::type_id::create("seq_rst");
			seq_rst.start(env.agnt.seq);
			
		#10;

                        seq_wr=fifo_sequence_wr::type_id::create("seq_wr");
			seq_wr.start(env.agnt.seq);

                #4;
		     	seq_rd= sequence_fifo_rd::type_id::create("seq_rd");
			seq_rd.start(env.agnt.seq);
		#10;
			
		phase.drop_objection(this);
	endtask
	
       function void end_of_elaboration_phase(uvm_phase phase);
         super.end_of_elaboration_phase(phase);
         uvm_root::get().print_topology();
       endfunction
endclass