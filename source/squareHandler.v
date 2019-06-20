`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:30 05/08/2019 
// Design Name: 
// Module Name:    squareHandler 
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
module squareHandler(
		input wire clk,
		input wire RST_BTN,
		input wire [7:0] speed,
		input wire [3:0] instr,
		output wire Hsync,       // horizontal sync output
      output wire Vsync,       // vertical sync output
      output wire [2:0] vgaRed,    // 3-bit VGA red output
      output wire [2:0] vgaGreen,    // 3-bit VGA green output
      output wire [2:0] vgaBlue,   // 2-bit VGA blue output
		output wire [47:0] squareState
    );
	 
	 reg [2:0] nextFreeSquareA;
	 reg [2:0] nextFreeSquareB;
	 reg [2:0] nextFreeSquareC;
	 reg [2:0] nextFreeSquareD;
	 reg [47:0] squareState;

	 reg [23:0] enable;
	 	 
	 always @ (posedge clk) begin
			if(RST_BTN) begin
				speed <= 1;
				enable <= 24'b0;
				nextFreeSquareA <= 0;
				nextFreeSquareB <= 0;
				nextFreeSquareC <= 0;
				nextFreeSquareD <= 0;
			end
			
			if (instr[0]) begin
				enable[nextFreeSquareA] <= 1;
				if(nextFreeSquareA == 3'd5)
					nextFreeSquareA <= 3'd0;
				else nextFreeSquareA <= nextFreeSquareA + 1'b1;
			end
			if (instr[1]) begin
				enable[nextFreeSquareB + 6] <= 1'b1;
				if(nextFreeSquareB == 3'd5)
					nextFreeSquareB <= 3'd0;
				else nextFreeSquareB <= nextFreeSquareB + 1'b1;
			end
			if (instr[2]) begin
				enable[nextFreeSquareC + 12] <= 1'b1;
				if(nextFreeSquareC == 3'd5)
					nextFreeSquareC <= 3'd0;
				else nextFreeSquareC <= nextFreeSquareC + 1'b1;
			end
			if (instr[3]) begin
				enable[nextFreeSquareD + 18] <= 1'b1;
				if(nextFreeSquareC == 3'd5)
					nextFreeSquareC <= 3'd0;
				else nextFreeSquareC <= nextFreeSquareC + 1'b1;
			end

		end

endmodule
