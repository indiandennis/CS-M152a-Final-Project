`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:50 05/07/2019 
// Design Name: 
// Module Name:    debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module inputHandler(
	input wire clk,
	inout wire [7:0] JB,
	output wire [3:0] instr
	);
	 
	 wire [3:0] btns;
	 
	 decoder numPadDecoder(
				.clk(clk),
				.Row(JB[7:4]),
				.Col(JB[3:0]),
				.DecodeOut(btns)
	 );
	 
	 debouncer numPadDeb(
					.clk(clk),
					.in(btns),
					.out(instr)
	 );


endmodule
