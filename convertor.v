module convertor
#(parameter OUT_FIR_WIDTH = 44,
  parameter IN_DAC_WIDTH = 14,
  parameter [IN_DAC_WIDTH-1:0] UNSIGNED_WIDTH = 8192)
(
	input signed [OUT_FIR_WIDTH-1:0] fir_out,
	output [IN_DAC_WIDTH-1:0] o_convertor
);

	assign o_convertor = fir_out[31:18] + UNSIGNED_WIDTH;

endmodule 