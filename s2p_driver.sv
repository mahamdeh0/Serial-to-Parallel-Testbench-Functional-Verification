`ifndef	S2P_DRIVER
`define	S2P_DRIVER

//include files
`include "s2p_transaction.sv"
`include "s2p_interface.sv"

class s2p_driver #(int N =8);

  //virtual interface 
  virtual s2p_interface s2p_interface_ins;

  //mailbox defining
  mailbox gen2drive;

  // constructor
  function new (virtual s2p_interface s2p_interface_ins , mailbox gen2drive);
    
    //connect interface
    this.s2p_interface_ins=s2p_interface_ins;
    
    //connect mailbox
    this.gen2drive=gen2drive;
    
  endfunction

  // This task is used to drive stimulus on the interface
  task drive ();

    //transaction object handler
    s2p_transaction s2p_transaction_ins;

    forever @(posedge s2p_interface_ins.clk , s2p_interface_ins.reset) begin 
      //transaction object instantiation
      s2p_transaction_ins=new();
      
      // get transactions
      gen2drive.get(s2p_transaction_ins);
      
      // writing on the interface
     s2p_interface_ins.data_in	= s2p_transaction_ins.data_in;

    end
  endtask

endclass

`endif
