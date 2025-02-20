 module fifo_coverage #(parameter ptr_width = 9,depth = 512,data_width = 8) 
(intfc  rif_cov);

logic temp_r_en;
logic temp_w_en;
logic temp_clearw;
logic temp_clearr;
logic full_temp;
logic empty_temp;

always_ff @(posedge rif_cov.w_clk)
     begin
     temp_clearw <= rif_cov.w_rst;
     temp_w_en <= rif_cov.w_inc;
	 full_temp<= rif_cov.wfull;
     end
always_ff @(posedge rif_cov.r_clk)
     begin
     temp_clearr <= rif_cov.r_rst;
     temp_r_en <= rif_cov.r_inc;
	 empty_temp<= rif_cov.rempty;
     end


// Write Operations Covergroup (triggered on w_clk)
covergroup tewrite @(posedge rif_cov.w_clk);

    c_reset: coverpoint rif_cov.w_rst {
        bins reset_asserted = {1};
        bins reset_deasserted = {0};
        bins reset_transition = {1, 0};  // Track transition from 1 to 0
    }

    c_fifo_empty: coverpoint rif_cov.rempty {
        bins empty = {1};
        bins not_empty = {0};
        bins near_empty = {0, 1}; // Adding near-empty state tracking
    }

    c_fifo_full: coverpoint rif_cov.wfull {
        bins full = {1};
        bins not_full = {0};
        bins near_full = {1, 0}; // Adding near-full state tracking
    }

    c_write_enable: coverpoint rif_cov.w_inc {
        bins write_enabled = {1};
        bins write_disabled = {0};
        bins toggle_write = {1, 0};  // Track toggling of write_enable signal
    }

    c_write_data: coverpoint rif_cov.wdata {
        bins data_values = {[0:255]};
        bins specific_data_values = {8'hFF, 8'h00};  // Track edge data values (e.g., 0xFF and 0x00)
    }

    c_read_enable: coverpoint rif_cov.r_inc {
        bins read_enabled = {1};
        bins read_disabled = {0};
        bins read_toggling = {1, 0};  // Track toggling of read_enable signal
    }

endgroup

// Read Operations Covergroup (triggered on r_clk)
covergroup tread @(posedge rif_cov.r_clk);

    c_read_enable: coverpoint rif_cov.r_inc {
        bins read_enabled = {1};
        bins read_disabled = {0};
        bins read_toggling = {1, 0};  // Track toggling of read_enable signal
    }

    c_read_reset: coverpoint rif_cov.r_rst {
        bins reset_asserted = {1};
        bins reset_deasserted = {0};
        bins reset_transition = {1, 0};  // Track transition from 1 to 0
    }

    c_read_data: coverpoint rif_cov.rdata {
        bins data_values = {[0:255]};
        bins specific_data_values = {8'hAA, 8'h55};  // Track edge data values (e.g., 0xAA and 0x55)
    }

    c_fifo_empty_status: coverpoint rif_cov.rempty {
        bins empty = {1};
        bins not_empty = {0};
        bins near_empty = {0, 1}; // Adding near-empty state tracking
    }

    c_fifo_full_status: coverpoint rif_cov.wfull {
        bins full = {1};
        bins not_full = {0};
        bins near_full = {1, 0}; // Adding near-full state tracking
    }

    c_write_enable_status: coverpoint rif_cov.w_inc {
        bins write_enabled = {1};
        bins write_disabled = {0};
        bins toggle_write = {1, 0};  // Track toggling of write_enable signal
    }

endgroup


/*

covergroup tewrite @(posedge rif_cov.w_clk);

c0:coverpoint rif_cov.w_rst{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint rif_cov.rempty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint rif_cov.wfull {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
c3 : coverpoint rif_cov.w_inc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint rif_cov.wdata {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint rif_cov.r_inc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }

endgroup

covergroup tread @(rif_cov.r_clk);
c5 : coverpoint rif_cov.r_inc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint rif_cov.r_rst {
             bins r_rst_n_high = {1};
			 bins r_rst_n_low = {0};
			 }			 

c7 : coverpoint rif_cov.rdata {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint rif_cov.rempty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint rif_cov.wfull {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint rif_cov.w_inc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

endgroup
*/

tewrite test_iw;
tread  test_ir;

initial begin
  test_iw = new();
  test_ir = new();

 end

endmodule 

