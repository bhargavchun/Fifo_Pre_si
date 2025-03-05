class driver extends uvm_driver #(fifo_seq_item);
	`uvm_component_utils(driver)
	virtual intfc vif;	
	
        fifo_seq_item pkt_drive; 
	function new(string name ="driver",uvm_component parent);
		super.new (name,parent);
		`uvm_info("You are in Driver class", "Inside New!",UVM_LOW)
	endfunction
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("You are in Driver class", "Inside Build_Phase!",UVM_LOW)
		
		if(!(uvm_config_db #(virtual intfc)::get(this,"*","vif",vif))) 
		begin
			`uvm_error("You are in Driver class", "Failed to get vif from config DB!")
		end
		
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("You are in Driver class", "Inside Connect_phase!",UVM_LOW)
		
	endfunction	
		
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("You are in Driver class", "Inside run_phase!",UVM_LOW)
		forever 
		 begin
			pkt_drive = fifo_seq_item#(8,8)::type_id::create("pkt_drive");
			seq_item_port.get_next_item(pkt_drive);
			drive(pkt_drive);
			seq_item_port.item_done();
		 end
    endtask
	
	
	task drive(fifo_seq_item pkt_drive);
		begin
		if (pkt_drive.w_rst & pkt_drive.r_rst) begin
			vif.w_rst <= pkt_drive.w_rst;
			vif.r_rst <= pkt_drive.r_rst;
		end
		else begin
			
			if(pkt_drive.w_inc & !pkt_drive.r_inc)
			  begin
			  vif.w_rst <= pkt_drive.w_rst;
				vif.r_rst <= pkt_drive.r_rst;
				vif.w_inc <= pkt_drive.w_inc;
				vif.r_inc <= pkt_drive.r_inc;
				vif.wdata <= pkt_drive.wdata;
				@(posedge vif.w_clk);			
				`uvm_info("Driver is doing write operation",$sformatf("Burst Details of FIFO:time=%0d,w_inc=%0d,r_inc=%0d,wdata=%0d,full=%0d,empty=%0d,waddr=%0d",$time,vif.w_inc,vif.r_inc,vif.wdata,vif.wfull,vif.rempty,vif.waddr),UVM_LOW) 
				
			  end
           
			if(pkt_drive.r_inc & !pkt_drive.w_inc)
			  begin
			    vif.w_rst <= pkt_drive.w_rst;
				vif.r_rst <= pkt_drive.r_rst;
				vif.r_inc <= pkt_drive.r_inc;
				vif.w_inc <= pkt_drive.w_inc;
				vif.wdata <= pkt_drive.wdata;
				 @(posedge vif.r_clk);
				`uvm_info("Driver is doing read operation",$sformatf("Burst Details of FIFO:time=%0d,w_inc=%0d,r_inc=%0d,data_out=%0d,full=%0d,empty=%0d,raddr=%0d",$time,vif.w_inc,vif.r_inc,vif.rdata,vif.wfull,vif.rempty,vif.raddr),UVM_LOW)
			    
			  end
			  
		end
	end
	endtask
endclass
    		 
			 
		
	
