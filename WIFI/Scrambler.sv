/* 
And before going on the the encoder which is the first sub-block: 
We need to add redundancy to the transmitted signal to improve its reliability and resistance to noise and interference.
*/
// And this is where Scrambler comes in.
/*
the Scrambler takes the data bits that are to be transmitted and scrambles them using a 
pseudorandom sequence generator before procceding further.
*/
//The Scrambler adds 127-bit sequence to the actual data.
//And here is the design............
//The Scrambler is used to randomize the data before it is transmitted
module Scrambler(input clk, input rst, output reg [6:0]state_out, input bit_in, output bit_out, output ready);
//The ready signal here is to trigger the encoder once the data field randomized.

	wire feedback;
	assign feedback =  (bit_in ^ state_out[6] ^ state_out[3]);
	assign bit_out = feedback; // Here is the bit output.

// THhe main operation
	always @(posedge clk)
	begin
		if (rst == 1'b1) 
			state_out <=  7'b1010000;  // The initial state.
		else
			state_out <= {state_out[5], state_out[4], state_out[3],state_out[2], state_out[1], state_out[0],feedback};
            ready=1'b1;
	end
endmodule