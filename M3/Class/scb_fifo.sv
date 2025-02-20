import fifo_pkg::*;
class scb_fifo;
mailbox monitor2scb;
int scb_trans,temp_trans;
	

 bit [7:0] data_queue[$];
 logic [7:0] checksb;
 int passcount,failcount;
	
  function new(mailbox monitor2scb);
      
      this.monitor2scb = monitor2scb;
  endfunction
	
	
    task main;
	
    forever begin
	 trans_fifo trans;
	  trans=new();
      monitor2scb.get(trans); 
	  if(trans.temp_trans1)
	  
	  begin
		if(trans.w_inc && !trans.wfull) 
		 begin
	        data_queue.push_front(trans.wdata);
                 $display("[Scoreboard] Pass: wdata = %0d, waddr = %0d", trans.wdata, trans.waddr);
	        passcount++;
		 end
		if(trans.r_inc && !trans.rempty)
		 begin
		
		checksb=trans.wdata;
		if(checksb !== trans.wdata)
		begin
               $display("[Scoreboard] Fail: Expected Data = %0d, Received Data = %0d at waddr = %0d", checksb, trans.rdata, trans.raddr);
		failcount++;
		 end
		else
		   begin
		  $display("[Scoreboard] Pass: rdata = %0d,  raddr= %0d", trans.rdata, trans.raddr);
	           passcount++;
			 end
		 end
        $display("##########^^^^############");
      scb_trans++;
	 end
	 else temp_trans = trans.temp_trans1;
    end
      $display("[Scoreboard] No.of Tests are failed=%0d and and No.of tests passed = %d",failcount,passcount);
  endtask
endclass
