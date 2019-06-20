`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:04:10 05/08/2019 
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
module debouncer(
	input wire clk,
	input wire in,
	output reg out
    );
	
	reg [17:0] counter;
	
	always @(posedge clk) begin
		if(in == 1'b1) begin
			if(counter == 18'b111111111111111111)
				counter <= 18'b111111111111111111;
			else
				counter <= counter + 1'b1;
			out <= 0;
		end
		else begin
			if(counter == 18'd0) begin
				counter <= 18'd0;
				out <= 0;
			end
			else begin
				counter <= counter - 1'b1;
				if (counter == 18'd200000)
					out <= 1;
				else 
					out <= 0;
			end
		end
			
	end

endmodule
