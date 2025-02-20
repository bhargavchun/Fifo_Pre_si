module async_fifo_tb;

  parameter D_SIZE = 8;
  parameter A_SIZE = 9;

  wire [D_SIZE-1:0] rdata;
  wire w_full;
  wire rempty;
  reg [D_SIZE-1:0] wdata;
  reg w_inc, w_clk, wrst_n;
  reg rinc, r_clk, rstn;


  reg [D_SIZE-1:0] verif_data_q[$];
  reg [D_SIZE-1:0] verif_wdata;


  async_fifo #(D_SIZE, A_SIZE) dut (.*);

  initial begin
    w_clk = 1'b0;
    r_clk = 1'b0;

    fork
      forever #2ns w_clk = ~w_clk;
      forever #4ns r_clk = ~r_clk;
    join
  end

  initial begin
    w_inc = 1'b0;
    wdata = '0;
    wrst_n = 1'b1;
    repeat(5) @(posedge w_clk);
    wrst_n = 1'b0;

    for (int iter=0; iter<2; iter++) begin
      for (int i=0; i<64; i++) begin
        @(posedge w_clk iff !w_full);
        w_inc = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_inc) begin
          wdata = $urandom;
          verif_data_q.push_front(wdata);
        end
      end
      #1us;
    end
  end

  initial begin
    rinc = 1'b0;

    rstn = 1'b1;
    repeat(8) @(posedge r_clk);
    rstn = 1'b0;

    for (int iter=0; iter<2; iter++) begin
      for (int i=0; i<64; i++) begin
        @(posedge r_clk iff !rempty)
        rinc = (i%2 == 0)? 1'b1 : 1'b0;
        if (rinc) begin
          verif_wdata = verif_data_q.pop_back();
          $display("Verifying the rdata: Passed at time %0t	expected wdata = %h, rdata = %h",$time, verif_wdata, rdata);
          assert(rdata === verif_wdata) else $error("Verifying the failed: Failed at time %0t	expected wdata = %h, rdata = %h",$time, verif_wdata, rdata);
        end
      end
      #1us;
    end

    $finish;
  end

endmodule

