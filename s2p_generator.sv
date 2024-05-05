`ifndef	S2P_GEN
`define	S2P_GEN

//include files
`include "s2p_transaction.sv"

class s2p_generator  #(int N =8);

  //number of transactions
  rand int num_of_trans;

  //mailbox defining
  mailbox gen2drive;

  function new ( mailbox gen2drive );
    
    this.gen2drive = gen2drive;
    
  endfunction

  // This task is used to generate stimulus and send it to Driver
  task gen_trans ();

    //transaction object handler
    s2p_transaction  #(.N(N)) s2p_transaction_ins;
    
    num_of_trans=$urandom_range(100,300);

    for (int i =0; i< num_of_trans; i++) begin 
      
      //transaction object instantiation
      s2p_transaction_ins=new();
      
      //transaction object randomization
      s2p_transaction_ins.randomize();

      // Write Trans to MailBox
      gen2drive.put(s2p_transaction_ins);
    end

  endtask

endclass

`endif