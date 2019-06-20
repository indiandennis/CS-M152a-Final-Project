`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 2011
// Engineer: Michelle Yu  
//				 Josh Sackos
// Create Date:    07/23/2012 
//
// Module Name:    Decoder
// Project Name:   PmodKYPD_Demo
// Target Devices: Nexys3
// Tool versions:  Xilinx ISE 14.1 
// Description: This file defines a component Decoder for the demo project PmodKYPD. The Decoder scans
//					 each column by asserting a low to the pin corresponding to the column at 1KHz. After a
//					 column is asserted low, each row pin is checked. When a row pin is detected to be low,
//					 the key that was pressed could be determined.
//
// Revision History: 
// 						Revision 0.01 - File Created (Michelle Yu)
//							Revision 0.02 - Converted from VHDL to Verilog (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////////////////////////////


module inputHandler(
    clk,
    Row,
    Col,
    out
    );

    input clk;						// 100MHz onboard clock
    input [3:0] Row;				// Rows on KYPD
    output [3:0] Col;			// Columns on KYPD
    output [3:0] out;	// Output data
	
	debouncer debA(
		.clk(clk),
		.in(~Row[0]),
		.out(out[3])
	);
	
	debouncer debB(
		.clk(clk),
		.in(~Row[1]),
		.out(out[2])
	);
	
	debouncer debC(
		.clk(clk),
		.in(~Row[2]),
		.out(out[1])
	);
	
	debouncer debD(
		.clk(clk),
		.in(~Row[3]),
		.out(out[0])
	);
	
	wire [3:0] Col;
	assign Col = 4'b1110;
	
	wire [3:0] out;

endmodule
