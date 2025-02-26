
class driver extends uvm_driver #(fifo_seq_item);
	`uvm_component_utils(driver)
	
	virtual intfc vif;	
	fifo_seq_item drv_pkt;	

	function new(string name ="driver",uvm_component parent);
		super.new (name,parent);
		`uvm_info("you are in driver class", "Inside new!!",UVM_LOW)
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("you are in driver class", "Inside build phase!!",UVM_LOW)
		
		if(!(uvm_config_db #(virtual intfc)::get(this,"*","vif",vif))) 
		begin
			`uvm_error("DRIVER CLASS", "Failed to get vif from config DB!")
		end
	endfunction
	
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("you are in driver class", "Inside Connect phase!!",UVM_LOW)
       endfunction	
		
			
		
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("you are in driver class", "Inside run phase!!",UVM_LOW)
		forever 
		 begin
			drv_pkt = fifo_seq_item#(8,9)::type_id::create("drv_pkt");
			seq_item_port.get_next_item(drv_pkt);
			drive(drv_pkt);
			seq_item_port.item_done();
		 end
    endtask
	
	
	task drive(fifo_seq_item drv_pkt);
		begin
		if (drv_pkt.w_rst & drv_pkt.r_rst) begin
			vif.w_rst <= drv_pkt.w_rst;
			vif.r_rst <= drv_pkt.r_rst;
		end
		else begin
			
			if(drv_pkt.w_inc & !drv_pkt.r_inc)
			  begin
			  vif.w_rst <= drv_pkt.w_rst;
				vif.r_rst <= drv_pkt.r_rst;
				vif.w_inc <= drv_pkt.w_inc;
				vif.r_inc <= drv_pkt.r_inc;
				vif.wdata <= drv_pkt.wdata;
				@(posedge vif.w_clk);			
				`uvm_info("Driver is doing write operation",$sformatf("Burst Details:time=%0d,w_inc=%0d,r_inc=%0d,wdata=%0d,full=%0d,empty=%0d,waddr=%0d",$time,vif.w_inc,vif.r_inc,vif.wdata,vif.wfull,vif.rempty,vif.waddr),UVM_LOW) 
				
			  end
            

			if(drv_pkt.r_inc & !drv_pkt.w_inc)
			  begin
			    vif.w_rst <= drv_pkt.w_rst;
				vif.r_rst <= drv_pkt.r_rst;
				vif.r_inc <= drv_pkt.r_inc;
				vif.w_inc <= drv_pkt.w_inc;
				vif.wdata <= drv_pkt.wdata;
				 @(posedge vif.r_clk);
				`uvm_info("Driver is doing read operation",$sformatf("Burst Details:time=%0d,w_inc=%0d,r_inc=%0d,data_out=%0d,full=%0d,empty=%0d,raddr=%0d",$time,vif.w_inc,vif.r_inc,vif.rdata,vif.wfull,vif.rempty,vif.raddr),UVM_LOW)
			    
			  end
			  
		end
	end
	endtask
endclass
   