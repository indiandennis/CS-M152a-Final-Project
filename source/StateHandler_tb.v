`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:49:30 05/23/2019
// Design Name:   StateHandler
// Module Name:   C:/Users/152/lab1group1/StateHandler/StateHandler_tb.v
// Project Name:  StateHandler
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: StateHandler
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module StateHandler_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] button_press;
	reg [47:0] square_locations;

	// Outputs
	wire [3:0] column;
	wire [19:0] sound;

	// Instantiate the Unit Under Test (UUT)
	StateHandler uut (
		.clk(clk), 
		.rst(rst), 
		.button_press(button_press), 
		.square_locations(square_locations),
		.column(column), 
		.sound(sound)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		square_locations = 0;
		button_press = 0;

		// Wait 100 ns for global reset to finish
		#20;
		rst = 0;
		#5
		square_locations = {{46{1'b0}}, 2'b01};
		button_press = 4'b0001;
		
		#1
		button_press = 0;
      
		#200;
		// Add stimulus here

	end
	
	always begin
		#1 clk = !clk;
	end
      
endmodule

