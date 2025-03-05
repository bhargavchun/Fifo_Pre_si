`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "fifo_seq_item.sv"
`include "sequence_fifo_wr.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_coverage.sv"
`include "fifo_env.sv"
`include "fifo_log.sv"
`include "fifo_test.sv"


module fifo_uvm_tb_top;
parameter DATASIZE=8;
parameter ADDRSIZE=8;
bit r_clk;
bit w_clk;
bit w_rst, r_rst;
intfc ifuvm(.w_clk(w_clk), .r_clk(r_clk), .w_rst(w_rst), .r_rst(r_rst));
Asynch_fifo_top #(.DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) t1 (.inf(ifuvm));
	initial begin
		uvm_config_db #(virtual intfc):: set(null, "*", "vif", ifuvm);
	end
	initial begin
		run_test("uvmtest");
	end
	
	always #4ns r_clk=~r_clk;
    always #2ns w_clk=~w_clk;
	
	initial begin
	    w_rst = 1;
		r_rst = 1;
		
		#15 w_rst = 0;
		#15 r_rst = 0;
    end

	
endmodule
