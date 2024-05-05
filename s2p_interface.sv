`ifndef	S2P_INTERFACE
`define	S2P_INTERFACE

interface s2p_interface(input logic clk,input logic reset);


  parameter         N =8     ;

  logic 		 	data_in  ;
  logic 		 	full_tick;
  logic 	[N-1:0] data_out ;

endinterface
`endif