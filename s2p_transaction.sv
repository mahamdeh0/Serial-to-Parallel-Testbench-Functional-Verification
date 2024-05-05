`ifndef	S2P_TRANSACTION
`define	S2P_TRANSACTION

class s2p_transaction # (int N =8) ;

  rand logic 	 	 	data_in  ;
  rand logic 			reset    ; 
  
  logic 			 	full_tick;
  logic 	[N-1:0] 	data_out ;
  
  
endclass
`endif