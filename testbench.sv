`ifndef TB_S2P
`define TB_S2P

`include "s2p_interface.sv"
`include "s2p_top.sv"

module tb_s2p;

  //Parameter decleration

  parameter N = 8;

  // Ports Definition

  bit clk, reset;

  // Clk Generation    

  initial begin 
    clk         = 0;
    reset       = 1;
    #10 reset 	= 0;

  end 

  always #5 clk = ~clk; 


  // Interface
  s2p_interface  #(.N(N)) s2p_interface_ins(clk,reset);

  //TOP Program
  s2p_top #(.N(N)) s2p_top_in (s2p_interface_ins);    

  // DUT Instantiation
  serial_to_parallel #(.N(N)) s2p_v1_ins  (
    
    .clk		(s2p_interface_ins.clk			),
    .reset		(s2p_interface_ins.reset		),
    .data_in	(s2p_interface_ins.data_in		),
    .full_tick	(s2p_interface_ins.full_tick	),
    .data_out	(s2p_interface_ins.data_out	    ));

  initial begin #1000; $finish; end

  initial begin $dumpfile("dump.vcd"); $dumpvars; end

endmodule
`endif