module fifomem#(parameter Data_size = 8,parameter Addr_size = 9)
(
  input   w_inc, w_full, w_clk,
  input   [Addr_size-1:0] waddr, raddr,
  input   [Data_size-1:0] wdata,
  output  [Data_size-1:0] rdata
);


  localparam depth = 1<<Addr_size;

  logic [Data_size-1:0] mem [0:depth-1];

  assign rdata = mem[raddr];

  always_ff @(posedge w_clk)
    if (w_inc && !w_full)
      mem[waddr] <= wdata;

endmodule



