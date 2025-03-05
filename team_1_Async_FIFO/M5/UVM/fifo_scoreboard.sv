
class fifo_scoreboard extends uvm_test;
	`uvm_component_utils(fifo_scoreboard)
	bit [7:0]trans_data[$];
	 fifo_seq_item trans[$];
	 bit [8:0] wr_sach;
	  bit [8:0] writer_sach[$];
	 uvm_analysis_imp #(fifo_seq_item,fifo_scoreboard) scoreboard_port; 

    function new(string name= "scoreboard",uvm_component parent);
		super.new(name,parent);
		`uvm_info("You are in scoreboard class", "Inside new!!",UVM_LOW)
	endfunction
	
	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
		`uvm_info("You are in scoreboard class", "Inside Build_phase!!",UVM_LOW)
		
		scoreboard_port = new("scoreboard_port",this);// creating new constructor for scoreboard analysis port
		
		endfunction
		
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		`uvm_info("You are in scoreboard class", "Connect_phase!!",UVM_LOW)
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("You are in scoreboard class", "Inside Run_phase!!",UVM_LOW)
	 forever 
	 begin

	 fifo_seq_item curr_trans;
	    wait(trans.size!=0);
		curr_trans=trans.pop_back();
		read(curr_trans);
	 end
	endtask
	 
	function void write(fifo_seq_item seqitem);
	 trans.push_front(seqitem);
	 
	   if(seqitem.w_inc &!seqitem.wfull)
	   begin
		trans_data.push_front(seqitem.wdata);
		writer_sach.push_front(seqitem.waddr[8:0]);
		`uvm_info("Scoreboard write wdata",$sformatf("Burst Details of FIFO:w_inc=%d, wdata=%d, wfull=%0d",seqitem.w_inc, seqitem.wdata, seqitem.wfull),UVM_LOW) 
		
		if(seqitem.waddr[8:0]!=0)
		begin
		wr_sach =writer_sach.pop_back();
		if(seqitem.waddr[8:0]!=wr_sach[8:0]+1'b1)
		`uvm_info("##########^^^^^^Scoreboard write data_in ^^^^^^^#############",$sformatf("*********************ERROR ************* : present_wptr = %0d  and previous_wptr= %0d ",seqitem.waddr[8:0],wr_sach[8:0]),UVM_LOW) 
		end
		end
	endfunction
	
	task read(fifo_seq_item read_trans);
	   bit [7:0] expected_data;
	   bit [7:0] actual;
	
	   if(read_trans.r_inc &!read_trans.rempty)
	   begin
		actual = read_trans.rdata;
	    expected_data= trans_data.pop_back();
		`uvm_info("Scoreboard getting read wdata",$sformatf("Burst Details of FIFO:r_inc=%d, wdata=%d, wfull=%0d",read_trans.r_inc, read_trans.wdata, read_trans.rempty),UVM_LOW)
		end
		
		if(actual != expected_data) begin
		`uvm_error("While comparing read", $sformatf("transaction was failed actual=%d, expected_data=%d", actual,expected_data)) 
		end
		
		else begin
		`uvm_info("While comparing read", $sformatf("transaction was passed actual=%d, expected_data=%d", actual,expected_data), UVM_LOW) 
		end
		
	endtask	
		
endclass
	
	

	 
