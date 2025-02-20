import fifo_pkg::*;

class gen_fifo;

trans_fifo transx, endtransx; 
mailbox  genrator2driv; 
int count, size,temp_trans=0;
event ended;
	
function new(mailbox  genrator2driv, event ended);
  this.genrator2driv = genrator2driv;
  this.ended=ended;		
endfunction

task main();
int i;
endtransx =new();
endtransx.temp_trans=0;
$display("######^^^^######");
$display("[Generator] Main task started, size=%0d, count=%0d", size, count);
repeat(size) 
begin
	
for(int j=0;j<count;j++)
 begin 
  transx =new();
  if(j<=count/2) 
   begin
    assert(transx.randomize() with {transx.w_inc==0;transx.r_inc==1;});
    end     
		
  if (j>count/2) 
   begin
    assert(transx.randomize() with {transx.w_inc==1;transx.r_inc==0;});
   end

   $display("[Generator] Sending transaction: w_inc=%0d, r_inc=%0d, wdata=%0d",transx.w_inc, transx.r_inc, transx.wdata);
   genrator2driv.put(transx); 
   i++;	
    end
	end
   endtransx.temp_trans=1;
   genrator2driv.put(endtransx);
 $display("[Generator] Generator task completed.");
 $display("######^^^^######");
  endtask
	
endclass
