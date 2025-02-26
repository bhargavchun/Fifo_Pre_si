import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_sequence extends uvm_sequence;
	
	`uvm_object_utils (fifo_sequence)
	
	fifo_seq_item fifo_pkt; 
	
	function new( string name = "fifo_sequence");
		super.new (name);
		`uvm_info("you are in fifo_sequence class", "Inside Constructor!", UVM_LOW)
	endfunction
	 
	 

		task body();
		begin
		    `uvm_info("FIFO_SEQUENCE","INSIDE THE TASK BODY!",UVM_LOW)
			fifo_pkt = fifo_seq_item#(8,9)::type_id ::create ("fifo_pkt");
			start_item(fifo_pkt);
			fifo_pkt.no_rst.constraint_mode(0);
			assert (fifo_pkt.randomize() with {fifo_pkt.w_rst==1;fifo_pkt.r_rst==1;});
			`uvm_info("you are in fifo_sequence_wr class",$sformatf("Generate new item:%s",fifo_pkt.convert2str()),UVM_LOW)
			$display("####################################### you are in reset body ####################################################");
			finish_item(fifo_pkt);
	    end
	endtask
	
endclass
	  
	  
class fifo_sequence_wr extends uvm_sequence;
	
	`uvm_object_utils (fifo_sequence_wr) 	
	fifo_seq_item fifo_pkt_wr; 
	
		function new( string name = "fifo_sequence_wr");
		super.new (name);
		`uvm_info("you are in fifo_sequence_wr class","Inside of new!",UVM_LOW)
	endfunction
	 
	 
	int num=16;
		task body();
		for (int i=0; i<num;i++) begin
		    `uvm_info("you are in fifo_sequence_wr class","Inside of Task body!",UVM_LOW)
			fifo_pkt_wr = fifo_seq_item#(8,9)::type_id ::create ("fifo_pkt_wr");
			start_item(fifo_pkt_wr);
			assert (fifo_pkt_wr.randomize() with {w_inc==1 ; r_inc==0;});
			`uvm_info("you are in fifo_sequence_wr class",$sformatf("Generate new item:%s",fifo_pkt_wr.convert2str()),UVM_LOW)
			$display("#####################################################^^^^^^^^^^^^^^###################################################################");
			finish_item(fifo_pkt_wr);
			`uvm_info("you are in fifo_sequence_wr class",$sformatf(" Done Generate new item: %d",i),UVM_LOW)
	    end
		 `uvm_info("SEQ",$sformatf(" Done Generation of items: %d",num),UVM_LOW)
	endtask
	
endclass


class sequence_fifo_rd extends uvm_sequence;
	
	`uvm_object_utils (sequence_fifo_rd) 	
	fifo_seq_item fifo_rd_pkt; 
	
		function new( string name = "sequence_fifo_rd");
		super.new (name);
		`uvm_info("FIFO_READ_SEQUENCE", "Inside Constructor!", UVM_LOW)
	endfunction
	 
    int num=16;
		task body();
		for (int i=0; i<num;i++) begin
		    `uvm_info("you are in fifo_sequence_rd class","Inside of Task body!",UVM_LOW)
			fifo_rd_pkt = fifo_seq_item#(8,9)::type_id::create ("fifo_rd_pkt");
			start_item(fifo_rd_pkt);
			assert (fifo_rd_pkt.randomize() with {w_inc==0 & r_inc==1;});
			`uvm_info("you are in fifo_sequence_rd class",$sformatf("Generate new item:%s",fifo_rd_pkt.convert2str()),UVM_LOW)
			
			$display("###########################################################^^^^^^^^^^^^^^######################################################################");
			finish_item(fifo_rd_pkt);
			`uvm_info("you are in fifo_sequence_rd class",$sformatf(" done Generate new item: %d",i),UVM_LOW)
		end
		 `uvm_info("you are in fifo_sequence_rd class",$sformatf(" Done Generation of items: %d",num),UVM_LOW)
	endtask
	
endclass	 