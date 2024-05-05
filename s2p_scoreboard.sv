`ifndef	S2P_SCOREBOARD
`define	S2P_SCOREBOARD

//include files
`include "s2p_transaction.sv"

class s2p_scoreboard;

  //mailbox defining
  mailbox mon2score;
  mailbox ref2score;

  // constructor
  function new (mailbox mon2score , mailbox ref2score);

    //connect mailboxes
    this.mon2score	= mon2score;
    this.ref2score 	= ref2score;
  endfunction

  // This task is used to drive stimulus on the interface
  task comp ();

    //transaction object handler
    s2p_transaction s2p_transaction_exp_ins;
    s2p_transaction s2p_transaction_act_ins;

    forever begin 
      //transaction object instantiation
      s2p_transaction_exp_ins=new();   
      s2p_transaction_act_ins=new();

      // get transactions from mailboxes
      ref2score.get(s2p_transaction_exp_ins);
      mon2score.get(s2p_transaction_act_ins);

      //check if exp == act
      if (s2p_transaction_exp_ins.data_out === s2p_transaction_act_ins.data_out && s2p_transaction_exp_ins.full_tick === s2p_transaction_act_ins.full_tick)
        begin
          $display ("exp_data_out:%b is equal the act_data_out:%b",s2p_transaction_exp_ins.data_out,s2p_transaction_act_ins.data_out);
          $display ("exp_full_tick:%b is equal the act_full_tick:%b",s2p_transaction_exp_ins.full_tick,s2p_transaction_act_ins.full_tick);
        end
      else 
        begin
          $display ("exp_data_out:%b is NOT equal the act_data_out:%b",s2p_transaction_exp_ins.data_out,s2p_transaction_act_ins.data_out);
          $display ("exp_full_tick:%b is NOT equal the act_full_tick:%b",s2p_transaction_exp_ins.full_tick,s2p_transaction_act_ins.full_tick);
        end
    end
  endtask

endclass

`endif