module readptr_empty #(parameter A_SIZE=8)( r_clk, r_rst, r_inc, wptr_sync, raddr, rptr, rempty, hempty);

input bit r_clk, r_rst, r_inc;
input logic [A_SIZE:0] wptr_sync;
output bit rempty;
output bit hempty;
output logic [A_SIZE:0] raddr, rptr;


logic temp_rempty;
logic reg_rempty;
logic calc_rempty;

logic [A_SIZE:0] next_raddr;
logic [A_SIZE:0] next_rptr;
logic [A_SIZE:0] bin_wptr_sync;
//injected bug as per Milestone-5
`ifdef BUG_INJECTED_MILESTONE
assign bin_wptr_sync = gray_to_bin(wptr_sync);
assign next_raddr = raddr + (r_inc & rempty);
assign next_rptr = (next_raddr >> 1) & next_raddr ^raddr;

`else
assign bin_wptr_sync = gray_to_bin(wptr_sync);
assign next_raddr = raddr + (r_inc & !rempty);
assign next_rptr = (next_raddr >> 1) ^ next_raddr;

`endif


function automatic logic [A_SIZE:0] gray_to_bin(input logic [A_SIZE:0] gray);
    logic [A_SIZE:0] binary;
    binary[A_SIZE] = gray[A_SIZE];

    for (int i = A_SIZE-1; i >= 0; i--) begin
        binary[i] = gray[i] ^ binary[i+1];
    end

    return binary;
endfunction

always_ff @(posedge r_clk or posedge r_rst)
begin
    if (r_rst) begin
        raddr <= 0;
        rptr <= 0;
    end
    else begin
        raddr <= next_raddr;
        rptr <= next_rptr;
    end
end

always_ff @(posedge r_clk or posedge r_rst)
begin
    if (r_rst)
        rempty <= 1;
    else
        rempty <= temp_rempty;
end

assign hempty = (next_raddr[A_SIZE-1:0] - bin_wptr_sync[A_SIZE-1:0] >= 172);
assign temp_rempty = (wptr_sync == next_rptr);

property P_rreset;
    @(posedge r_clk)
    disable iff (r_rst)
    r_rst |=> (raddr == '0 && rptr == '0);
endproperty
a_rreset: assert property (P_rreset)
else
    $error("assertion failed in read reset");

property P_rempty;
    @(posedge r_clk)
    disable iff (r_rst)
    r_rst |=> (rempty == '1);
endproperty
a_rempty: assert property (P_rempty)
else
    $error("assertion failed in empty condition");

property P_empty;
    @(posedge r_clk)
    disable iff (r_rst)
    rempty |=> (!r_inc);
endproperty
a_empty: assert property (P_empty)
else
    $error("assertion was failed when read from an empty FIFO is happening");

endmodule










 
