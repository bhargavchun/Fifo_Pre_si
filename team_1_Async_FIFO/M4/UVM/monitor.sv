class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
virtual intfc vif; 
fifo_seq_item mon_pkt;
uvm_analysis_port #(fifo_seq_item) monitor_port; 


function new (string name="monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("you are in monitor class", "Inside new!!",UVM_LOW)
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("you are in monitor class", "Inside build phase!!",UVM_LOW)
	monitor_port = new("monitor_port", this);//creating a new constructor for monitor annalysis port
	if(!(uvm_config_db # (virtual intfc):: get (this, "*", "vif", vif))) 
	begin
	`uvm_error (" you are in monitor class", "Failed to get vif from config DB!")
	end
endfunction


function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("you are in monitor class", "Inside connect phase!!",UVM_LOW)
endfunction


task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("you are in monitor class", "Inside run phase!!",UVM_LOW)
	
	forever begin
		mon_pkt = fifo_seq_item #(8,9)::type_id::create("mon_pkt");
		wait (!vif.w_rst && !vif.r_rst);
       
		if(vif.w_inc & !vif.r_inc)
		begin
			@(posedge vif.w_clk);
		
			mon_pkt.w_inc=vif.w_inc;
			mon_pkt.r_inc=vif.r_inc;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.wdata= vif.wdata;
			mon_pkt.rdata= vif.rdata;
			mon_pkt.wfull= vif.wfull;
			mon_pkt.rempty= vif.rempty;
			`uvm_info("Monitoring the Write operation",$sformatf("Burst Dtails:time=%0d,w_inc=%d,r_inc=%d,wdata=%d,wfull=%0d,rempty=%0d, waddr=%d,",$time,vif.w_inc,vif.r_inc,vif.wdata,vif.wfull,vif.rempty,vif.waddr),UVM_LOW) 
		end
		
		if(vif.r_inc & !vif.w_inc)
		begin
		    @(posedge vif.r_clk);
			mon_pkt.w_inc=vif.w_inc;
			mon_pkt.r_inc=vif.r_inc;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.wdata= vif.wdata;
			mon_pkt.rdata= vif.rdata;
			mon_pkt.wfull= vif.wfull;
			mon_pkt.rempty= vif.rempty;
			`uvm_info("Monitoring the Read operation",$sformatf("Burst Dtails:time=%0d,w_inc=%d,r_inc=%d,rdata=%d,wfull=%0d,rempty=%0d, raddr=%d",$time,vif.w_inc,vif.r_inc,vif.rdata,vif.wfull,vif.rempty,vif.raddr),UVM_LOW)
			
		end
		monitor_port.write(mon_pkt); 
	end
endtask

endclass