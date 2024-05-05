`ifndef	S2P_MONETOR
`define	S2P_MONETOR

//include files
`include "s2p_transaction.sv"
`include "s2p_interface.sv"

class s2p_monetor #(int N =8);

  //virtual interface 
  virtual s2p_interface s2p_interface_ins;

  //mailbox defining
  mailbox mon2ref;
  mailbox mon2score;

  // constructor
  function new (virtual s2p_interface s2p_interface_ins , mailbox mon2ref , mailbox mon2score);
    
    //connect interface
    this.s2p_interface_ins	= s2p_interface_ins;
    
    //connect mailboxes
    this.mon2ref	= mon2ref;
    this.mon2score 	= mon2score;
  endfunction

  // This task is used to drive stimulus on the interface
  task input_mon ();

    //transaction object handler
    s2p_transaction s2p_transaction_in_ins;

    forever @(negedge s2p_interface_ins.clk , s2p_interface_ins.reset) begin 
      //transaction object instantiation
     s2p_transaction_in_ins=new();   
      
      // reading inputs from interface
      s2p_transaction_in_ins.reset   	= s2p_interface_ins.reset;
      s2p_transaction_in_ins.data_in	= s2p_interface_ins.data_in;
      
      // get transactions
      mon2ref.put(s2p_transaction_in_ins);            
    end
  endtask

   // This task is used to drive stimulus on the interface
  task output_mon ();

    //transaction object handler
    s2p_transaction s2p_transaction_out_ins;
    
    @(negedge s2p_interface_ins.clk , s2p_interface_ins.reset);

    
    forever @(negedge s2p_interface_ins.clk , s2p_interface_ins.reset) begin 
      //transaction object instantiation
      s2p_transaction_out_ins=new();
            
      // reading outputs from interface
      s2p_transaction_out_ins.full_tick		= s2p_interface_ins.full_tick;
      s2p_transaction_out_ins.data_out		= s2p_interface_ins.data_out;      
      
      // get transactions
      mon2score.put(s2p_transaction_out_ins);
    end
  endtask
  
endclass

`endif

