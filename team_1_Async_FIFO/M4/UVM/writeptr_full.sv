
module writeptr_full #(parameter A_SIZE = 9)(w_clk, w_rst, w_inc,  rptr_sync,  waddr, wptr, wfull);

input bit w_clk, w_rst, w_inc;
input logic [A_SIZE:0] rptr_sync;

output bit wfull;
output logic [A_SIZE:0] waddr, wptr;

logic internal_wwfull;
logic [A_SIZE:0] internal_waddr_next; 
logic [A_SIZE:0] internal_wptr_next;

assign internal_waddr_next = waddr + (w_inc & !wfull);
assign internal_wptr_next = (internal_waddr_next >> 1) ^ internal_waddr_next;

always_ff@(posedge w_clk or posedge w_rst)
begin
    if(w_rst)
    begin
        waddr <= '0; 
        wptr <= '0;
    end 
    else 
    begin
        waddr <= internal_waddr_next;
        wptr <= internal_wptr_next;
    end
end

always_ff@(posedge w_clk or posedge w_rst)
begin
    if(w_rst)
        wfull <= 0;
    else
        wfull <= internal_wwfull;
end

assign internal_wwfull = (internal_wptr_next == {~rptr_sync[A_SIZE:A_SIZE-1], rptr_sync[A_SIZE-2:0]}); // write full Condition

endmodule












 