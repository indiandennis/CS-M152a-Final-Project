`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:58:01 04/09/2019 
// Design Name: 
// Module Name:    display 
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
module display(
	 input wire clk,
    input wire [3:0] thousands,
	 input wire [3:0] hundreds,
	 input wire [3:0] tens,
	 input wire [3:0] ones,
    input wire enable,
	 output wire [7:0] seg,
	 output reg [3:0] an
    );
	 
	 reg [3:0] num;
	 //around 3khz clock
	 reg [13:0] div = 0;
	 reg [1:0] disp;
	 
 
	 numToSeg nts(
			.num(num),
			.seg(seg)
	 );
		 
	 always @ (posedge clk) begin
			div <= div + 1'b1;
			if (div == 0)
				disp <= disp + 1'b1;
		end	
		
		
	always @ (posedge clk) begin
		if (enable) begin
			//output val to anode based on disp
			case (disp)
				0: begin
					an <= 4'b1110;
					num <= ones;
					end
				1: begin
					an <= 4'b1101;
					num <= tens;
					end
				2: begin
					an <= 4'b1011;
					num <= hundreds;
					end
				3: begin
					an <= 4'b0111;
					num <= thousands;
					end
				default: begin
					an <= 0;
					num <= 0;
				end
			endcase
		end
		else begin 
			num <= 8'b1;
			an <= 4'b1;
		end
	end

endmodule
