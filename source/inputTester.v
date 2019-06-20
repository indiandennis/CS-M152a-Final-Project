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
	 output wire [3:0] an,
	 output wire [7:0] seg
    );
	 
	 //reg [7:0] speed;
	 wire [3:0] btn;
	 reg [3:0] score4, score3, score2, score1;
	
	 
	 inputHandler numPad(
				.clk(clk),
				.Row(JB[7:4]),
				.Col(JB[3:0]),
				.out(btn)
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
	 
	 always @(posedge clk)begin
		if(btn == 4'b0001)
			score1 <= score1 + 1;
		else if(btn == 4'b0010)
			score2 <= score2 + 1;
		else if(btn == 4'b0100)
			score3 <= score3 + 1;
		else if(btn == 4'b1000)
			score4 <= score4 + 1;
		
			
	 end
	 
		

endmodule
