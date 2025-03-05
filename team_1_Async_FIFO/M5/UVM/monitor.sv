class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
virtual intfc vif; 
fifo_seq_item pket_seq_mon;
uvm_analysis_port #(fifo_seq_item) monitor_port; 

function new (string name="monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("You are in Monitor class", "Inside New!!",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("You are in Monitor class", "Inside Build_phase!",UVM_LOW)
	monitor_port = new("monitor_port", this);
	if(!(uvm_config_db # (virtual intfc):: get (this, "*", "vif", vif))) 
	begin
	`uvm_error ("You are in Monitor class", "Failed to get vif from config DB!")
	end
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("You are in Monitor class", "Inside Connect_phase!",UVM_LOW)
endfunction

task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("You are in Monitor class", "Inside Run_phase!",UVM_LOW)
	
	forever begin
		pket_seq_mon = fifo_seq_item #(8,8)::type_id::create("pket_seq_mon");
		wait (!vif.w_rst && !vif.r_rst);
       
		if(vif.w_inc & !vif.r_inc)
		begin
			@(posedge vif.w_clk);
		
			pket_seq_mon.w_inc=vif.w_inc;
			pket_seq_mon.r_inc=vif.r_inc;
			pket_seq_mon.waddr= vif.waddr;
			pket_seq_mon.raddr=vif.raddr;
			pket_seq_mon.wdata= vif.wdata;
			pket_seq_mon.rdata= vif.rdata;
			pket_seq_mon.wfull= vif.wfull;
			pket_seq_mon.rempty= vif.rempty;
			`uvm_info("Monitoring the Write operation",$sformatf("Burst Details of FIFO:time=%0d,w_inc=%0d,r_inc=%0d,wdata=%0d,wfull=%0d,hfull=%0d,rempty=%0d,hempty=%0d,waddr=%0d,",$time,vif.w_inc,vif.r_inc,vif.wdata,vif.wfull,vif.hfull,vif.rempty,vif.hempty,vif.waddr),UVM_LOW) 
		end
		
		if(vif.r_inc & !vif.w_inc)
		begin
		    @(posedge vif.r_clk);
			pket_seq_mon.w_inc=vif.w_inc;
			pket_seq_mon.r_inc=vif.r_inc;
			pket_seq_mon.waddr= vif.waddr;
			pket_seq_mon.raddr=vif.raddr;
			pket_seq_mon.wdata= vif.wdata;
			pket_seq_mon.rdata= vif.rdata;
			pket_seq_mon.wfull= vif.wfull;
			pket_seq_mon.rempty= vif.rempty;
			`uvm_info("Monitoring the Read operation",$sformatf("Burst Details of FIFO:time=%0d,w_inc=%0d,r_inc=%0d,rdata=%0d,wfull=%0d,hfull=%0d,rempty=%0d,hempty=%0d,raddr=%0d",$time,vif.w_inc,vif.r_inc,vif.rdata,vif.wfull,vif.hfull,vif.rempty,vif.hempty,vif.raddr),UVM_LOW)
			
		end
		monitor_port.write(pket_seq_mon); 
	end
endtask

endclass