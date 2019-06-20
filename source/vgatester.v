`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:45 05/08/2019 
// Design Name: 
// Module Name:    tester 
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
module tester(
	 input wire clk,
	 input wire RST_BTN,
	 inout wire [7:0] JB,
    output wire Hsync, 
    output wire Vsync, 
    output wire [2:0] vgaRed, 
    output wire [2:0] vgaGreen,
    output wire [2:0] vgaBlue
    );
	 
	 wire [3:0] btn;
	 wire [47:0] squareState;
	 
	 inputHandler numPad(
				.clk(clk),
				.Row(JB[7:4]),
				.Col(JB[3:0]),
				.out(btn)
	 );
	 
	 squareHandler graphics(
			.clk(clk),
			.RST_BTN(RST_BTN),
			.speed(2'd2),
			.instr(btn),
			.remove(0),
			.Hsync(Hsync),
			.Vsync(Vsync),
			.vgaRed(vgaRed),
			.vgaGreen(vgaGreen),
			.vgaBlue(vgaBlue),
			.squareState(squareState),
			.alive(1)
	 );
	 
		

endmodule
