import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_sequence extends uvm_sequence;
	`uvm_object_utils (fifo_sequence) 
         fifo_seq_item pket_seq; 
	function new( string name = "fifo_sequence");
		super.new (name);
		`uvm_info("you are in fifo_sequence class", "Inside new!!", UVM_LOW)
	endfunction
	 
	 task body();
		begin
		   pket_seq = fifo_seq_item#(8,8)::type_id ::create ("pket_seq");
			start_item(pket_seq);
			pket_seq.no_rst_fseq.constraint_mode(0);
			assert (pket_seq.randomize() with {pket_seq.w_rst==1;pket_seq.r_rst==1;});
			`uvm_info("you are in fifo_sequence class",$sformatf("Generate new item: %s",pket_seq.convert2str()),UVM_LOW)
			$display("####################################### you are in reset body ####################################################");
			finish_item(pket_seq);
	    end
	endtask
	
endclass
	  
	  
class fifo_sequence_wr extends uvm_sequence;
	
	`uvm_object_utils (fifo_sequence_wr) 
	fifo_seq_item pket_seq_wr; 
	function new( string name = "fifo_sequence_wr");
		super.new (name);
		`uvm_info("you are in fifo_sequence_wr class", "Inside Constructor!", UVM_LOW)
	endfunction
	 
	 
	int k=256;
	
	task body();
		for (int i=0; i<k;i++) begin
		     pket_seq_wr = fifo_seq_item#(8,8)::type_id ::create ("pket_seq_wr");
			start_item(pket_seq_wr);
			assert (pket_seq_wr.randomize() with {w_inc==1 ; r_inc==0;});
			`uvm_info("you are in fifo_sequence_wr class",$sformatf("Generate new item: %s",pket_seq_wr.convert2str()),UVM_LOW)
			$display("#####################################################^^^^^^^^^^^^^^###################################################################");
			finish_item(pket_seq_wr);
			`uvm_info("you are in fifo_sequence_wr class",$sformatf("Generate new item: %0d",i),UVM_LOW)
	    end
		 `uvm_info("you are in fifo_sequence_wr class",$sformatf("Generated items: %d",k),UVM_LOW)
	endtask
	
endclass


class sequence_fifo_rd extends uvm_sequence;
	
	`uvm_object_utils (sequence_fifo_rd) 
	
	fifo_seq_item pket_seq_rd;
	function new( string name = "sequence_fifo_rd");
		super.new (name);
		`uvm_info("you are sequence_fifo_rd class", "Inside Constructor!", UVM_LOW)
	endfunction
	 
    int k=256;
	
	task body();
		for (int i=0; i<k;i++) begin
		    pket_seq_rd = fifo_seq_item#(8,8)::type_id::create ("pket_seq_rd");
			start_item(pket_seq_rd);
			assert (pket_seq_rd.randomize() with {w_inc==0 & r_inc==1;});
			`uvm_info("you are sequence_fifo_rd class",$sformatf("Generate new item:%s ",pket_seq_rd.convert2str()),UVM_LOW)
			
			$display("#####################################################^^^^^^^^^^^^^^###################################################################");
			finish_item(pket_seq_rd);
			`uvm_info("you are sequence_fifo_rd class",$sformatf("Generate new item: %0d",i),UVM_LOW)
		end
		 `uvm_info("you are sequence_fifo_rd class",$sformatf("Generated items: %d",k),UVM_LOW)
	endtask
	
endclass	
	
