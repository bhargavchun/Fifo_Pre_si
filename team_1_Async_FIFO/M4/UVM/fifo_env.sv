class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)
         agent agnt;
	fifo_scoreboard scb; 
	
	function new(string name ="env" , uvm_component parent);
		super.new(name,parent);
		`uvm_info("you are in fifo_env class", "Inside new!!",UVM_LOW)
	endfunction

	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("you are in fifo_env class", "Inside build phase!!",UVM_LOW)
		agnt = agent::type_id::create("agnt",this);
		scb = fifo_scoreboard:: type_id::create("scb", this);
	endfunction
	
	
       function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("you are in fifo_env class", "Inside connect phase!!",UVM_LOW)
		agnt.mon.monitor_port.connect(scb.scoreboard_port);//connecting monitor analysis port to scoreboard analysis port
     endfunction
	
	
	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("you are in fifo_env class", "Inside run phase!!",UVM_LOW)
	endtask
endclass
		
	
	
	
	