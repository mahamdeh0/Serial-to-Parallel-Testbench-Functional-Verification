`ifndef	S2P_TOP
`define	S2P_TOP

//include files
`include "s2p_interface.sv"
`include "s2p_environment.sv"

program s2p_top # (int N=8) (s2p_interface s2p_interface_ins);

  //virtual interface
  virtual s2p_interface s2p_interface_ins_h;
  
  //environment instance
  s2p_environment #(.N(N)) s2p_environment_ins;
  
  initial begin
    //connect virtual interface
    s2p_interface_ins_h = s2p_interface_ins;
    
    //objects instantiation
    s2p_environment_ins = new (s2p_interface_ins_h);   
    
    //call run method
     s2p_environment_ins.run();
  end

endprogram

`endif