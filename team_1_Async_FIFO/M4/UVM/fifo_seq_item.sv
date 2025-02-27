
class fifo_seq_item #(parameter  DATASIZE = 8, ADDRSIZE = 9) extends uvm_sequence_item;

    rand bit w_inc;
    rand bit r_inc;
    rand bit w_rst;
    rand bit r_rst;
    rand bit [DATASIZE-1:0] wdata;
    bit [DATASIZE-1:0] rdata;
    bit rempty, wfull;
    bit [ADDRSIZE:0] waddr, raddr;
      
    `uvm_object_utils_begin(fifo_seq_item #(DATASIZE,ADDRSIZE)) // registering the class to factory

 // Using UVM field macros for automation
    `uvm_field_int(w_inc, UVM_ALL_ON)
    `uvm_field_int(r_inc, UVM_ALL_ON)
    `uvm_field_int(w_rst, UVM_ALL_ON)
    `uvm_field_int(r_rst, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(rempty, UVM_ALL_ON)
    `uvm_field_int(wfull, UVM_ALL_ON)
    `uvm_field_int(waddr, UVM_ALL_ON)
    `uvm_field_int(raddr, UVM_ALL_ON)
  
    `uvm_object_utils_end
    
    // Constraint for reset
    constraint no_rst { w_rst == 0 && r_rst == 0; }

    // Ensure write and read do not happen simultaneously when reset is asserted
    constraint reset_behavior {
        (w_rst || r_rst) -> (w_inc == 0 && r_inc == 0);
    }

    // Ensure that write increment is allowed only when FIFO is not full
    constraint write_control {
        w_inc -> !wfull;
    }

    // Ensure that read increment is allowed only when FIFO is not empty
    constraint read_control {
        r_inc -> !rempty;
    }

    // Ensure wdata is within the valid range
    constraint valid_data_range {
        wdata inside {[0:(1 << DATASIZE) - 1]};
    }

    // Prevent simultaneous read and write in certain cases (optional, depends on design)
    constraint no_simul_read_write {
        !(w_inc && r_inc && wfull && rempty);
    }

    function string convert2str();
        return $sformatf("w_inc =%0d, r_inc =%0d, wdata =%0d", w_inc, r_inc, wdata);
    endfunction

    // Creating a new constructor for sequence item class
    function new (string name = "fifo_seq_item");
        super.new(name);
    endfunction
endclass



