

module fifomem #(parameter D_Size = 8,parameter A_Size = 9)( w_clk,r_clk,r_rst,w_rst,w_inc,r_inc,wfull,rempty, wdata,  waddr,raddr,  rdata);

input bit w_clk,r_clk,r_rst,w_rst,w_inc,r_inc,wfull,rempty;
input logic [A_Size:0]  waddr, raddr;

input logic [D_Size-1:0] wdata;
output logic [D_Size-1:0]rdata;

localparam mem_depth = 1<<A_Size;

logic [D_Size-1:0] fifo [0: mem_depth-1];

always_ff@(posedge w_clk)
begin
if(w_inc & !wfull)
begin
fifo[waddr[A_Size-1:0]]<=wdata; // operation for write
end
end
assign rdata=fifo[raddr[A_Size-1:0]]; // operation for read
endmodule
