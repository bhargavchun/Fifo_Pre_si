class fifo_log extends uvm_report_server;
`uvm_object_utils(fifo_log)

function new (string name="fifo_log");
	super.new();
	$display( "Report Stats %0s",name);
endfunction


virtual function string compose_message( uvm_severity severity,string name,string id,string message,string filename,int line );
	$display("%0s",super.compose_message(severity,name,id,message,filename,line));
endfunction

endclass

