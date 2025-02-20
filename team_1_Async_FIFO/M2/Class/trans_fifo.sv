import fifo_pkg::*;
class trans_fifo;

    parameter  d_width =8, p_width = 8;
	rand bit w_inc;
	rand bit r_inc;
	randc bit [d_width-1:0] wdata;
	int temp_trans,temp_trans1;
	bit [d_width-1:0] rdata;
	bit rempty, wfull;
	bit [p_width:0] waddr;
	bit [p_width:0]raddr;
	 int burst_id;

   constraint c_address_range {
        waddr inside {[0: (2**p_width)-1]}; // waddr must be within valid range
        raddr inside {[0: (2**p_width)-1]};
    }

  constraint c_data_values {
        wdata inside {[0: (2**d_width)-1]}; // wdata can be any value in the data width
        rdata inside {[0: (2**d_width)-1]}; // rdata follows similar constraint
    }

    constraint c_fifo_states {
    // wfull has a higher likelihood of being 0 (not full)
    wfull dist {0 := 90, 1 := 10}; // '0' is more likely to occur

    // rempty has a higher likelihood of being 0 (not empty)
    rempty dist {0 := 90, 1 := 10}; // '0' is more likely to occur
}

endclass