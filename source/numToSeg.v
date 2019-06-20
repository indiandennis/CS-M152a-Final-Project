`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:54 04/09/2019 
// Design Name: 
// Module Name:    numToSeg 
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
module numToSeg(
	input wire [3:0] num,
	output reg [7:0] seg
	);
	
	always @* begin
		case (num)
			4'd0: seg = 8'b11000000;
			4'd1: seg = 8'b11111001;
			4'd2: seg = 8'b10100100;
			4'd3: seg = 8'b10110000;
			4'd4: seg = 8'b10011001;
			4'd5: seg = 8'b10010010;
			4'd6: seg = 8'b10000010;
			4'd7: seg = 8'b11111000;
			4'd8: seg = 8'b10000000;
			4'd9: seg = 8'b10010000;
			default: seg = 8'b11111111;
		endcase

	end

endmodule
