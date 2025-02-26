
module readptr_empty #(parameter A_Size=9)( r_clk, r_rst, r_inc,   wptr_sync,  raddr, rptr,  rempty);

input bit r_clk,r_rst, r_inc;
input logic [A_Size:0]  wptr_sync;
output bit rempty;
output logic [A_Size:0] raddr, rptr;

logic internal_raddr_flag;
logic internal_rptr_flag;

logic [A_Size:0] internal_next_raddr;
logic [A_Size:0] internal_next_rptr;

assign internal_next_raddr = raddr + (r_inc & !rempty);
assign internal_next_rptr = (internal_next_raddr >> 1) ^ internal_next_raddr;
assign internal_raddr_flag = (wptr_sync == internal_next_rptr);

always_ff@(posedge r_clk or posedge r_rst)
begin
    if (r_rst)
    begin
        raddr <= 0; 
        rptr <= 0;
    end
    else
    begin
        raddr <= internal_next_raddr;
        rptr <= internal_next_rptr;
    end
end

always_ff@(posedge r_clk or posedge r_rst)
begin
    if (r_rst)
        rempty <= 1;
    else
        rempty <= internal_raddr_flag;
end

endmodule