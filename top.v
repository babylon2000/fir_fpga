module top
#(parameter INPUT_WIDTH = 16,
  parameter HEIGHT_ADDR = 16,
  parameter COUNT_WIDTH = 32,
  parameter DAC_WIDTH = 14,
  parameter OUT_FIR_WIDTH = 44)
(
	input i_clk,
	input [3:0] sw,
	output i_clk_to_dac,
	//output signed [INPUT_WIDTH-1:0] fir_in,
	//output signed [OUT_FIR_WIDTH-1:0] fir_out,
	output [DAC_WIDTH-1:0] dac_in
);

	reg [INPUT_WIDTH-1:0] sine_rom [(2**HEIGHT_ADDR-1):0];
	reg [COUNT_WIDTH-1:0] cnt;
	reg signed [INPUT_WIDTH-1:0] fir_in_reg;
	
	reg [13:0] tmp;
	
	wire signed [INPUT_WIDTH-1:0] fir_in;
	wire signed [OUT_FIR_WIDTH-1:0] fir_out;
				
	assign i_clk_to_dac = ~i_clk;
	assign fir_in = fir_in_reg;

	initial begin 
		$readmemh("E:\\fpga\\labs\\fir_full\\sine_rom.hex", sine_rom);
	end
	
	fir fir_inst(.clk(i_clk),
	             .aclr(1'b0),
					 .ena(1'b1),
					 .y(fir_in),
					 .o_data(fir_out));
					 
	/*convertor convertor_inst(.fir_out(fir_out),
	                         .o_convertor(dac_in));*/

	always @(posedge i_clk) begin
		fir_in_reg <= sine_rom[cnt[31:16]];
	end	
	
	always @(posedge i_clk) begin
		cnt <= cnt + (sw << 25);
	end
	
	always @(posedge i_clk) begin
		tmp<=fir_out[30:17] + 8192;
	end

	assign dac_in = tmp;

endmodule 