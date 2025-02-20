import fifo_pkg::*;
class mon_fifo;

	
	virtual intfc vir_inf;
    

    mailbox monitor2scb;
	
  
	function new(virtual intfc vir_inf, mailbox monitor2scb);
		
		this.vir_inf = vir_inf;
		 
		this.monitor2scb = monitor2scb;
   endfunction
   int temp_num, mon_transfer,burst_id=1;
   
 
	
   task main; 
    trans_fifo transx;
	forever 
		begin

			transx = new(); 
			transx.temp_trans1=0;
			wait(vir_inf.w_inc | vir_inf.r_inc);
			
			if( (!vir_inf.r_inc) & vir_inf.w_inc  ) 
			 begin
			    @(posedge vir_inf.w_clk);
				transx.w_inc = vir_inf.w_inc;
				transx.r_inc = vir_inf.r_inc;
				transx.waddr = vir_inf.waddr;
				transx.raddr = vir_inf.raddr;
				transx.wdata = vir_inf.wdata;
				transx.wfull = vir_inf.wfull;
				transx.rempty = vir_inf.rempty;
				transx.rdata = vir_inf.rdata;
			
                          
                                $display("[Monitor][Write Transaction_ID : %0d]----w_inc = %0d,r_inc = %0d, wdata = %0d, rempty = %0d,wfull = %0d,waddr = %0d",mon_transfer,vir_inf.w_inc,vir_inf.r_inc, vir_inf.wdata, vir_inf.rempty, vir_inf.wfull, vir_inf.waddr);
                        end
          
			if((!vir_inf.w_inc) & vir_inf.r_inc )  
			 begin
			    @(posedge vir_inf.r_clk);
			        transx.w_inc = vir_inf.w_inc;
				transx.r_inc = vir_inf.r_inc;
				transx.waddr = vir_inf.waddr;
				transx.raddr = vir_inf.raddr;
				transx.wdata = vir_inf.wdata;
				transx.wfull = vir_inf.wfull;
				transx.rempty = vir_inf.rempty;
				transx.rdata = vir_inf.rdata;
				$display("[Monitor][Read Transaction_ID : %0d]----w_inc = %0d,r_inc = %0d,rempty = %0d,wfull = %0d,rdata = %0d,raddr = %0d",mon_transfer,vir_inf.w_inc,vir_inf.r_inc, vir_inf.rempty, vir_inf.wfull, vir_inf.rdata, vir_inf.raddr);
			 end
			monitor2scb.put(transx);
		    transx.temp_trans1=1;
			mon_transfer++;
		end
		
	endtask
endclass

