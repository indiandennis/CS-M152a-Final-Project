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
    output wire [2:0] vgaBlue,
	 output wire [3:0] an,
	 output wire [7:0] seg,
	 output wire [7:0] Led,
	 output wire pin_enable
    );
	 
	 //reg [7:0] speed;
	 wire [3:0] btn;
	 wire [3:0] instr;
	 wire [19:0] sound;
	 wire [23:0] remove;
	 wire [47:0] squareState;
	 wire [3:0] score4, score3, score2, score1;
	 wire alive;
	 wire [7:0] speed;
	
	 StateHandler state(
				.clk(clk),
				.rst(RST_BTN),
				.button_press(btn),
				.square_locations(squareState),
				.column(instr),
				.sound(sound),
				.remove(remove),
				.Led(Led),
				.score4(score4),
				.score3(score3),
				.score2(score2),
				.score1(score1),
				.alive(alive),
				.speed(speed)
	 );
	 
	 Speaker sp (
		.clk (clk),
		.i_note (sound),
		.speed(speed),
		.pin_enable (pin_enable)
	 );
	 
	 inputHandler numPad(
				.clk(clk),
				.Row(JB[7:4]),
				.Col(JB[3:0]),
				.out(btn)
	 );
	 
	 squareHandler graphics(
			.clk(clk),
			.RST_BTN(RST_BTN),
			.speed(speed),
			.instr(instr),
			.remove(remove),
			.Hsync(Hsync),
			.Vsync(Vsync),
			.vgaRed(vgaRed),
			.vgaGreen(vgaGreen),
			.vgaBlue(vgaBlue),
			.squareState(squareState),
			.alive(alive)
	 );
	 
	 display disp(
			.clk(clk),
			.thousands(score4),
			.hundreds(score3),
			.tens(score2),
			.ones(score1),
			.enable(1),
			.seg(seg),
			.an(an)
	 );
	 
	 
		

endmodule
