module writeptr_full #(parameter A_Size = 8)(w_clk, w_rst, w_inc, rptr_sync, waddr, wptr, wfull, hfull);
input bit w_clk, w_rst, w_inc;
input logic [A_Size:0] rptr_sync;
output bit wfull;
output bit hfull;
output logic [A_Size:0] waddr, wptr;


logic temp_wfull;
logic [A_Size:0] next_waddr;
logic [A_Size:0] next_wptr;
logic [A_Size:0] bin_rptr_sync;

 //injected bug as per Milestone-5
`ifdef BUG_INJECTED_MILESTONE5
assign next_waddr = waddr + (w_inc & wfull);     
assign next_wptr = (next_waddr >> 1) & next_waddr;
assign bin_rptr_sync = gray_to_bin(rptr_sync);
`else
assign next_waddr = waddr + (w_inc & !wfull);
assign next_wptr = (next_waddr >> 1) ^ next_waddr;
assign bin_rptr_sync = gray_to_bin(rptr_sync);
`endif

function automatic logic [A_Size:0] gray_to_bin(input logic [A_Size:0] gray);
    logic [A_Size:0] binary;

    binary[A_Size] = gray[A_Size];

    for (int i = A_Size-1; i >= 0; i--) begin
        binary[i] = gray[i] ^ binary[i+1];
    end

    return binary;
endfunction

always_ff @(posedge w_clk or posedge w_rst)
begin
    if (w_rst) begin
        waddr <= '0;
        wptr <= '0;
    end
    else begin
        waddr <= next_waddr;
        wptr <= next_wptr;
    end
end

always_ff @(posedge w_clk or posedge w_rst)
begin
    if (w_rst)
        wfull <= 0;
    else
        wfull <= temp_wfull;
end

assign hfull = (next_waddr[A_Size-1:0] - bin_rptr_sync[A_Size-1:0] >= 172);
assign temp_wfull = (next_wptr == {~rptr_sync[A_Size:A_Size-1], rptr_sync[A_Size-2:0]}); 

property P_wreset;
    @(posedge w_clk)
    disable iff(w_rst)
    w_rst |=> ((waddr == '0) & (wptr == '0));
endproperty
a_reset: assert property(P_wreset)
else
    $error("assertion failed in write reset");

property P_wfull;
    @(posedge w_clk)
    disable iff(w_rst)
    w_rst |=> wfull == '0;
endproperty
a_wfull: assert property(P_wfull)
else
    $error("Assertion was failed in write full condition");

property P_full;
    @(posedge w_clk)
    disable iff(w_rst)
    wfull |=> (!w_inc);
endproperty
a_full: assert property(P_full)
else
    $error("Assertion was failed when in write to a full FIFO");
endmodule













 
