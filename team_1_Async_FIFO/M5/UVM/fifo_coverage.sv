class fifo_coverage extends uvm_test ;
`uvm_component_utils(fifo_coverage)
uvm_analysis_imp #(fifo_seq_item, fifo_coverage) coverage_port;
real score1_fifo;
real score2_fifo;
real score3_fifo;
fifo_seq_item seq_pktr;


// Covergroup to monitor the address activity in the FIFO memory space
covergroup grp_memory with function sample(fifo_seq_item seq_pktr);
    // Cover write address values across the full range (0 to 256)
    cvp_waddr: coverpoint seq_pktr.waddr {
       bins waddr[] = {[0:256]};
    }

   // Cover read address values across the full range (0 to 256)
    cvp_raddr: coverpoint seq_pktr.raddr {
       bins raddr[] = {[0:256]};
    }

endgroup



// Covergroup to monitor **write-side** signals and conditions
covergroup t_wr with function sample(fifo_seq_item w_pkt);

  // Covering write-side reset condition (whether reset is active or not)
    cvp_w_rst: coverpoint w_pkt.w_rst {
             bins RESET_1 = {1};
             bins RESET_0 = {0};
    }

    // Covering `rempty` flag as seen from the write side
    // This is useful to check if the write side detects FIFO as empty
    cvp_rempty: coverpoint w_pkt.rempty {
             bins fifo_rempty_1 = {1};
             bins fifo_rempty_0 = {0};
    }

   // Covering `wfull` flag (write full) indicating if FIFO is full
    cvp_wfull: coverpoint w_pkt.wfull {
             bins fifo_wfull_1 = {1};
             bins fifo_wfull_0 = {0};
    }

   // Covering the write increment signal (`w_inc`)
    // This tells us whether a write operation was attempted
    cvp_w_inc: coverpoint w_pkt.w_inc {
             bins write_1 = {1};
             bins write_0 = {0};
    }

     // Covering all possible values of write data (wdata)
    // This ensures all 8-bit data values are exercised
    cvp_wdata: coverpoint w_pkt.wdata {
             bins wr_data = {[0:255]};
    }

    // Covering read increment signal (`r_inc`), as seen from the write side
    // This is useful for cross-domain observation (write side seeing read events)
    cvp_r_inc: coverpoint w_pkt.r_inc {
             bins read_1 = {1};
             bins read_0 = {0};
    }

endgroup


// Covergroup to monitor **read-side** signals and conditions
covergroup t_rd with function sample(fifo_seq_item r_pkt);

     // Covering read increment signal (`r_inc`), which triggers a read operation
    cvp_r_inc: coverpoint r_pkt.r_inc {
             bins read_1 = {1};
             bins read_0 = {0};
    }

     // Covering read-side reset condition
    // This tracks whether the read domain is held in reset
    cvp_r_rst: coverpoint r_pkt.r_rst {
             bins r_rst_high = {1};
             bins r_rst_low = {0};
    }

    // Covering all possible values of read data (rdata)
    // Ensures all 8-bit data values are observed during read operations
    cvp_rdata: coverpoint r_pkt.rdata {
             bins rd_data = {[0:255]};
    }

     // Covering `rempty` flag as seen from the read side
    // Checks if the read side correctly detects FIFO empty condition
    cvp_rempty: coverpoint r_pkt.rempty {
             bins fifo_rempty_1 = {1};
             bins fifo_rempty_0 = {0};
    }

    // Covering `wfull` flag (write full) as seen from the read side
    // Observing how the read side sees the full condition, which is rare
    cvp_wfull: coverpoint r_pkt.wfull {
             bins fifo_wfull_1 = {1};
             bins fifo_wfull_0 = {0};
    }

endgroup


function new (string name="coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("COVERAGE CLASS", "Inside Constructor!", UVM_LOW)
grp_memory=new();
t_wr=new();
t_rd=new();
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COVERAGE CLASS", "Build Phase!", UVM_HIGH)
   
    coverage_port = new("coverage_port", this); 
endfunction
  

function void write(fifo_seq_item t);
grp_memory.sample(t);
t_rd.sample(t);
t_wr.sample(t);

endfunction


function void extract_phase(uvm_phase phase);
   super.extract_phase(phase);
  score1_fifo=grp_memory.get_coverage();
score2_fifo=t_wr.get_coverage();
score3_fifo=t_rd.get_coverage();
endfunction


function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("You are in Coverage class",$sformatf("score1_fifo=%0f%%",score1_fifo),UVM_MEDIUM);
	`uvm_info("You are in Coverage class",$sformatf("score2_fifo=%0f%%",score2_fifo),UVM_MEDIUM);
	`uvm_info("You are in Coverage class",$sformatf("score3_fifo=%0f%%",score3_fifo),UVM_MEDIUM);
endfunction

endclass
