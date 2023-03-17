
/*
First of all, We have our TX block that contains the following sub-blocks which we'll design 
later on:

Scrambler -> Encoder -> Interleaver -> Mapper -> IFFT -> GI Adder.

The output of these blocks we'll be added to the preamble and it's worth mentioning that the order 
of sending them is crucial, so we need to transmit the preamble, signal, and the data. in order.

After that, -> OFDM-based Modulation.
*/


//Header params. Which are provided from the controller.
// For the header: Encoding tech is BPSK, with code rate of 1/2 and should be transmitted at a rate of 6 Mbps.
// And it is worth noticing that the header params. are not scrambled.(Randomized).
bit [3:0] data_rate; // Transmitting rate ******important*******
bit reserved;  // for future use, always set to 0
bit [11:0] length; // Ranging from 1 - 4095. Which defines the number of data octets in the pkt.******important*******
bit parity;
bit [5:0] tail; // 000000
bit [15:0] service; // QoS and Security.

/*
Once the Controller has received the PHY req., it generates and transmits the preamble and the header sections
of the msg foramt. -> So we don't need to worry about these configurations. and we need to focus on the Data part.
*/
//And by the way, here is Preamble generator.
//////////////////////////////////
// The preamble contains 12 symbols, 4 bits for each of wich.
//This preamble is sent fisrt to establish and sync. the communication.
//Since the preamble is fixed, it can be saved on the controller and provided once a new PHY req. received.
module preamble_generator (input clk, output [47:0] preamble );
reg [3:0] stf [9:0]; // Short Training seq., 40 bits in length.
reg [3:0] ltf [1:0]; // Long Training seq., 8 bits in length.
genvar i;
// initializing both.
initial begin
    stf[0] = 4'b0001;
    stf[1] = 4'b1101;
    stf[2] = 4'b0101;
    stf[3] = 4'b1011;
    stf[4] = 4'b0011;
    stf[5] = 4'b1110;
    stf[6] = 4'b0110;
    stf[7] = 4'b1000;
    stf[8] = 4'b0000;
    stf[9] = 4'b0000;
end

initial begin
    ltf[0] = 4'b0000;
    ltf[1] = 4'b0000;
end
reg [3:0] preamble_bits_short [11:0]; // preamble bits  12* 4 = 48 bits.
reg [3:0] preamble_bits_long [1:0];
// build preamble from short training sequence and long training sequence
    for (i = 0; i < 10; i = i + 1) begin
        assign preamble_bits_short[i] = stf[i];
    end
    for (i = 0; i < 2; i = i + 1) begin
        assign preamble_bits_long[i] = ltf[i];
    end
// output preamble
assign preamble = {preamble_bits_short, preamble_bits_long}; // as symbols
endmodule
//////////////////////////
// After forming the header section, the Controller appends the msg data and the trailling 0s.
bit [3:0] data_in [];  // Should be scrambled.
bit [5:0] d_tail = 6'b000000; // to indicate the end of the data_in bit stream.
/////////////////////////

