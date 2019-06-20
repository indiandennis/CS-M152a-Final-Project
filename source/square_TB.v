`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:24:44 05/09/2019
// Design Name:   square
// Module Name:   /home/ise/ise-shared/vgatest/square_TB.v
// Project Name:  vgatest
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: square
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module square_TB;

	// Inputs
	reg i_clk;
	reg enable;
	reg [3:0] column;
	reg [7:0] speed;
	reg i_ani_stb;
	reg i_rst;
	reg i_animate;

	// Outputs
	wire [11:0] o_x1;
	wire [11:0] o_x2;
	wire [11:0] o_y1;
	wire [11:0] o_y2;
	wire [1:0] state;

	// Instantiate the Unit Under Test (UUT)
	square uut (
		.i_clk(i_clk), 
		.enable(enable), 
		.column(column), 
		.speed(speed), 
		.i_ani_stb(i_ani_stb), 
		.i_rst(i_rst), 
		.i_animate(i_animate), 
		.o_x1(o_x1), 
		.o_x2(o_x2), 
		.o_y1(o_y1), 
		.o_y2(o_y2), 
		.state(state)
	);

	initial begin
		// Initialize Inputs
		i_clk = 0;
		enable = 0;
		column = 4'b0001;
		speed = 1;
		i_ani_stb = 0;
		i_rst = 1;
		i_animate = 0;

		// Wait 100 ns for global reset to finish
		#1000;
      i_rst = 0;
		// Add stimulus here
		enable = 1;
		#10000000 $finish;

	end
	
	always
		#10 i_clk = !i_clk;
	
	always begin
		#1000 i_animate = !i_animate;
		#1000 i_ani_stb = !i_ani_stb;
	end
      
endmodule

