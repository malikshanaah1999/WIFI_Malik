module Scrambler(input clk, input rst,  input bit_in, output scramb_bit);

	reg [6:0] state;
	wire feedback;
	assign feedback = (state[6] ^ state[3]);
	assign scramb_bit =  (bit_in ^ feedback);

	always @(posedge clk)
	begin
		if (rst == 1'b1) 
			state <=  7'b1010000;  // The initial state.
		else
			state <= {state[6], state[5], state[4],state[3], state[2], state[1],feedback};
	end
endmodule
