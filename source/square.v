// FPGA VGA Graphics Part 1: Square Animation
// (C)2017-2018 Will Green - Licensed under the MIT License
// Learn more at https://timetoexplore.net/blog/arty-fpga-vga-verilog-01


module square #(
    H_SIZE=25,      // half square width (for ease of co-ordinate calculations)
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire i_clk,         // base clock
	 input wire enable,
	 input wire [3:0] column,
	 input wire [7:0] speed,
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
	 input wire btn,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2,   // square bottom edge
	 output reg [1:0] state   //square state, higher bit is if at bottom, lower bit is if in push zone
    );
	 	 
    reg [11:0] x;   // horizontal position of square centre
    reg [11:0] y;   // vertical position of square centre

    assign o_x1 = x - H_SIZE;  // left: centre minus half horizontal size
    assign o_x2 = x + H_SIZE;  // right
    assign o_y1 = y - H_SIZE;  // top
    assign o_y2 = y + H_SIZE;  // bottom

    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
				case (column)
						4'b1000:
							x <= 180;
						4'b0100:
							x <= 275;
						4'b0010:
							x <= 370;
						4'b0001:
							x <= 465;
						default:
							x <= 500;
				endcase
				y <= 0;
				state <= 2'b0;
        end
		  if (i_animate && i_ani_stb)
        begin
				if (enable) begin
					case (column)
						4'b1000:
							x <= 180;
						4'b0100:
							x <= 275;
						4'b0010:
							x <= 370;
						4'b0001:
							x <= 465;
						default:
							x <= 500;
					endcase
					
					//handle checking if in zone
					if (y > 417 && y < 463) begin
						state <= 2'b01;
						y <= y + speed;
					end
					else if (y > 480) begin
						state <= 2'b10;
						y <= 0;
					end
					else begin
						state <= 2'b00;
						y <= y + speed;
					end
				end
				else begin
					y <= 0;
					state <= 2'b0;
				end
        end
		  else begin
				x <= x;
				y <= y;
				state <= state;
		  end
    end
endmodule
