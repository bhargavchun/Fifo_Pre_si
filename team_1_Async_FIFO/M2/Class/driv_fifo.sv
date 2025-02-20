import fifo_pkg::*;
class driv_fifo;
     mailbox genrator2driv;   
    virtual intfc vir_inf;         
                 
    int no_of_transaction,temp_trans; 

    
    function new(virtual intfc vir_inf, mailbox genrator2driv);
        this.vir_inf = vir_inf;
        this.genrator2driv = genrator2driv;
    endfunction

   
    task reset;  
        wait(vir_inf.w_rst);
      
        vir_inf.w_inc  <= 0;  
        vir_inf.wdata <= 0;
        vir_inf.wfull <= 0;
        wait(!vir_inf.w_rst); 
     
        wait(vir_inf.r_rst); 
      
        vir_inf.r_inc  <= 0; 
        vir_inf.wdata <= 0;
        vir_inf.rempty <= 0;
        wait(!vir_inf.r_rst); 
      
    endtask

    
    task drive; 
        trans_fifo trans; 
        forever begin
            trans = new(); 
          genrator2driv.get(trans);

            if (!trans.temp_trans) begin 
                if (trans.w_inc & !vir_inf.wfull) begin 
                    vir_inf.w_inc <= trans.w_inc;
                    vir_inf.r_inc <= trans.r_inc;
                    vir_inf.wdata <= trans.wdata;
                 
                  @(posedge vir_inf.w_clk); 
                    $display("[Driver][Write Transaction_ID : %0d]------driving to the DUT for write operation with these details--- w_inc = %0d,  r_inc = %0d, waddr = %d, wdata = %d",no_of_transaction, trans.w_inc, trans.r_inc, vir_inf.waddr, trans.wdata);
                end
                
                //  operation - read
                if (trans.r_inc & !vir_inf.rempty) begin 
                    vir_inf.r_inc <= trans.r_inc;
                    vir_inf.w_inc <= trans.w_inc;
                    vir_inf.wdata <= trans.wdata;
                    @(posedge vir_inf.r_clk); 
                    $display("[Driver][Read Transaction_ID : %0d]----driving to the DUT for read operation with these details--- r_inc = %0d, w_inc = %0d, raddr = %d",no_of_transaction,trans.r_inc, trans.w_inc, vir_inf.raddr);
                end
                no_of_transaction++;
                trans.temp_trans = 1; 
            end 
           else begin
                temp_trans = trans.temp_trans; 
            end
        end
    endtask

endclass


