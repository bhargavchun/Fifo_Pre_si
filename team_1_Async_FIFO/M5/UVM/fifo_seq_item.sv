import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_seq_item #(parameter D_Size =8, A_Size = 9)extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item #(8,9))
    rand bit w_inc;
	rand bit r_inc;
	rand bit w_rst;
	rand bit r_rst;
	rand bit [D_Size-1:0] wdata;
	bit [D_Size-1:0] rdata;
	bit rempty, wfull;
	bit [A_Size:0] waddr, raddr;
	
	constraint no_rst_fseq {w_rst == 0 && r_rst ==0;}
	
	function string convert2str();
	   return $sformatf ("w_inc =%0d, r_inc =%0d,data_in =%0d",w_inc,r_inc,wdata);
	endfunction
	
	
	function new (string name = "fifo_seq_item");
		super.new(name);
	endfunction
	endclass
		
	