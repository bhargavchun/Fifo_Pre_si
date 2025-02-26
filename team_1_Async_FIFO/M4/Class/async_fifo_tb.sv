
`include "interface.sv"
`include "test.sv"
`include "fifo_coverage.sv"

module fifo_testbench;
parameter DATASIZE = 8, ADDRSIZE = 9;
bit r_clk;
bit w_clk;
bit w_rst, r_rst;
always #4ns r_clk=~r_clk;
always #2ns w_clk=~w_clk;
	
	
    initial 
     begin
	    w_rst = 1;
	    r_rst = 1;
	    #50 w_rst = 0;
	    #50 r_rst = 0;
    end
	
	intfc intf(.w_clk(w_clk), .r_clk(r_clk), .w_rst, .r_rst); 
	
	test testdesign(intf); 
	
	
	Asynch_fifo_top #( .DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) topdesign(.inf(intf ));
	fifo_coverage #(8,256,8) coverage(intf.coverage);


endmodule