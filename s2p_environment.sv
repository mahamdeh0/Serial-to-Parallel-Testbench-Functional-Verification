`ifndef	S2P_ENVIROMENT
`define	S2P_ENVIROMENT

`include "s2p_interface.sv"
`include "s2p_driver.sv"
`include "s2p_generator.sv"
`include "s2p_monetor.sv"
`include "s2p_ref_mod.sv"
`include "s2p_scoreboard.sv"

class s2p_environment # (int N =8);

  //objects handler
  s2p_driver 	  #(.N(N))	s2p_driver_ins    ;
  s2p_generator   #(.N(N))	s2p_generator_ins ;
  s2p_monetor	  #(.N(N))	s2p_monetor_ins   ;
  s2p_ref_mod	  #(.N(N))	s2p_ref_mod_ins   ;
  s2p_scoreboard	        s2p_scoreboard_ins;
  
  //virtual interface
  virtual s2p_interface s2p_interface_ins;

  //mailbox defining
  mailbox gen2drive;
  mailbox mon2ref;
  mailbox mon2score;
  mailbox ref2score;

  function new(virtual s2p_interface s2p_interface_ins);
    
    //connect virtual interface
    this.s2p_interface_ins=s2p_interface_ins;

    //create nailbox
    gen2drive	=new();
    mon2ref		=new();
    mon2score	=new();
    ref2score	=new();

    //objects instantiation
    s2p_driver_ins 		= new (s2p_interface_ins , gen2drive           );
    s2p_generator_ins 		= new (gen2drive                          );
    s2p_monetor_ins 		= new (s2p_interface_ins , mon2ref   , mon2score );
    s2p_ref_mod_ins 	= new (mon2ref    , ref2score             );
    s2p_scoreboard_ins 	= new (mon2score  , ref2score             );


  endfunction

  task run();
    
    fork 
      begin
        s2p_generator_ins.gen_trans();
      end
      begin
        s2p_driver_ins.drive();
      end
      begin
  
        s2p_monetor_ins.input_mon();
      end
      begin
        s2p_monetor_ins.output_mon();
      end
      begin
        s2p_ref_mod_ins.ref_model();
      end
      begin
        s2p_scoreboard_ins.comp();
      end

    join
  endtask

endclass

`endif