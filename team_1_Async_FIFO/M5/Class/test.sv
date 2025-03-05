`include "environment.sv"
program test(intfc vir_inf);
	fifo_environment env;
	initial
    begin	
		env = new(vir_inf); 
		env.gen.count =1024;//burst for fifo
		env.gen.size =20; // burst size for fifo
		env.run();
	end
 endprogram