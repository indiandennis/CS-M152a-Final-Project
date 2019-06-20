`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:11:13 05/23/2019 
// Design Name: 
// Module Name:    Speaker 
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
module Speaker(
	input wire clk,
	input wire [19:0] i_note,
	input wire [7:0] speed,
	output reg pin_enable
    );
	 
	 reg [19:0] note;
	 reg [27:0] clk_div_duration;
	 reg [19:0] clk_div_frequency;
	 
	 always @(posedge clk) begin
		if(i_note != 0) begin
			// Incoming note
			clk_div_duration <= 1;
			clk_div_frequency <= 1;
			note <= i_note;
			pin_enable <= 1;
		end else begin		
			if(note != 0) begin
				// play note for half s
				if(clk_div_duration == 100000000) begin
					clk_div_duration <= 0;
					clk_div_frequency <= 0;
					note <= 0;
					pin_enable <= 0;
				end else begin
					clk_div_duration <= clk_div_duration + 1;
				end
				
				if(clk_div_frequency == note) begin
					pin_enable <= !pin_enable;
					clk_div_frequency <= 0;
				end else begin
					clk_div_frequency <= clk_div_frequency + 1;
				end
			end else begin
				// No note being played
				clk_div_duration <= 0;
				clk_div_frequency <= 0;
				note <= 0;
				pin_enable <= 0;
			end
		end
	 end


endmodule
