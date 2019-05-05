module muxWdoublein (input Asel,Bsel, input [15:0] A,B, output [15:0] out);
	assign out = Asel?A:Bsel?B:16'bz;
endmodule
