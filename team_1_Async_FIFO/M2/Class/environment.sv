import fifo_pkg::*;
class fifo_environment;

gen_fifo gen; //Generator
driv_fifo driv; // Driver
mon_fifo mon; // Monitor
scb_fifo scb; // Scoreboard

mailbox generator2d_mbx; 
mailbox monitor2s_mbx; 
   

event gen_ended;

virtual intfc vir_inf;

function new(virtual intfc vir_inf);

	this.vir_inf = vir_inf; 
	
	generator2d_mbx = new(); 
	monitor2s_mbx = new(); 
	
	
	gen = new(generator2d_mbx,gen_ended);
	driv = new(vir_inf,generator2d_mbx);
	mon = new(vir_inf,monitor2s_mbx);
	scb = new(monitor2s_mbx);
endfunction

//preset task for driver reset
task bef_test();
 driv.reset();
endtask

task test();
 fork
    gen.main(); 
	driv.drive(); 
	mon.main(); 
	scb.main(); 
 join_any
endtask


task aft_test();
 wait(scb.temp_trans ==0);
 wait(driv.temp_trans==1);
endtask


task run;
	bef_test();
	test();
	aft_test();
	$finish;
endtask

endclass

