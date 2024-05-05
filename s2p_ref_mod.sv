`ifndef	S2P_REF_MOD
`define	S2P_REF_MOD

//include files
`include "s2p_transaction.sv"

class s2p_ref_mod #(int N =8);

  //mailbox defining
  mailbox mon2ref;
  mailbox ref2score;

  // constructor
  function new (mailbox mon2ref , mailbox ref2score);

    //connect mailboxes
    this.mon2ref	= mon2ref;
    this.ref2score 	= ref2score;
  endfunction

  // This task is used to drive stimulus on the interface
  task ref_model  ();

    //transaction object handler
    s2p_transaction s2p_transaction_in_ins;
    s2p_transaction s2p_transaction_out_ins;
    
    int     count_reg =0;
    bit 	[N-1:0] 	data_out_intial, data_out_final;
    bit     full_tick;

    forever begin 
      //transaction object instantiation
      s2p_transaction_in_ins=new();   
      s2p_transaction_out_ins=new();

      // get transactions from monitor mailbox
      mon2ref.get(s2p_transaction_in_ins);

      if (s2p_transaction_in_ins.reset) begin
        
        count_reg 					 	    = 0;
        data_out_final 					    = 0;
        s2p_transaction_out_ins.full_tick 	= 0;
      end
      else 
        begin
          count_reg+=1;
          data_out_intial = data_out_intial >> 1;
          data_out_intial [N-1] = s2p_transaction_in_ins.data_in;

          if( count_reg !=N) begin
            full_tick =0;
          end

          if( count_reg ==N) begin
            full_tick =1;
            s2p_transaction_out_ins.full_tick = full_tick;
            count_reg = 0;
            data_out_final = data_out_intial;
          end
        end

      
      s2p_transaction_out_ins.data_out=data_out_final;
      s2p_transaction_out_ins.full_tick=full_tick;

      // send transactions to scoreboard usong the mailbox
      ref2score.put(s2p_transaction_out_ins);
    end
  endtask

endclass

`endif