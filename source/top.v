// FPGA VGA Graphics Part 1: Top Module
// (C)2017-2018 Will Green - Licensed under the MIT License
// Learn more at https://timetoexplore.net/blog/arty-fpga-vga-verilog-01


module squareHandler(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
	 input wire [7:0] speed,
	 input wire [3:0] instr,
	 input wire [23:0] remove,
	 input wire alive,
    output wire Hsync,       // horizontal sync output
    output wire Vsync,       // vertical sync output
    output wire [2:0] vgaRed,    // 3-bit VGA red output
    output wire [2:0] vgaGreen,    // 3-bit VGA green output
    output wire [2:0] vgaBlue,     // 2-bit VGA blue output
	 output reg [47:0] squareState
    );
	 
	 reg [2:0] nextFreeSquareA;
	 reg [2:0] nextFreeSquareB;
	 reg [2:0] nextFreeSquareC;
	 reg [2:0] nextFreeSquareD;

	 reg [23:0] enable;
	 
	 reg [4:0] i;
	
	 //set states based on square positions
	 always@ (posedge clk) begin
			squareState <= {state_a1, state_a2, state_a3, state_a4, state_a5, state_a6,
								 state_b1, state_b2, state_b3, state_b4, state_b5, state_b6,
								 state_c1, state_c2, state_c3, state_c4, state_c5, state_c6,
								 state_d1, state_d2, state_d3, state_d4, state_d5, state_d6};
			
			for(i = 0; i < 24; i = i + 1)
				if(remove[i])
					enable[i] <= 0;
				
			if(RST_BTN) begin
				enable <= 24'b0;
				nextFreeSquareA <= 0;
				nextFreeSquareB <= 0;
				nextFreeSquareC <= 0;
				nextFreeSquareD <= 0;
			end
			else if (instr != 4'b0) begin
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
					if(nextFreeSquareD == 3'd5)
						nextFreeSquareD <= 3'd0;
					else nextFreeSquareD <= nextFreeSquareD + 1'b1;
				end
			end
			else begin
				if(squareState[47])
					enable[23] <= 0;
				if(squareState[45])
					enable[22] <= 0;
				if(squareState[43])
					enable[21] <= 0;
				if(squareState[41])
					enable[20] <= 0;
				if(squareState[39])
					enable[19] <= 0;
				if(squareState[37])
					enable[18] <= 0;
				if(squareState[35])
					enable[17] <= 0;
				if(squareState[33])
					enable[16] <= 0;
				if(squareState[31])
					enable[15] <= 0;
				if(squareState[29])
					enable[14] <= 0;
				if(squareState[27])
					enable[13] <= 0;
				if(squareState[25])
					enable[12] <= 0;
				if(squareState[23])
					enable[11] <= 0;
				if(squareState[21])
					enable[10] <= 0;
				if(squareState[19])
					enable[9] <= 0;
				if(squareState[17])
					enable[8] <= 0;
				if(squareState[15])
					enable[7] <= 0;
				if(squareState[13])
					enable[6] <= 0;
				if(squareState[11])
					enable[5] <= 0;
				if(squareState[9])
					enable[4] <= 0;
				if(squareState[7])
					enable[3] <= 0;
				if(squareState[5])
					enable[2] <= 0;
				if(squareState[3])
					enable[1] <= 0;
				if(squareState[1])
					enable[0] <= 0;
			end
	 end

	 //creation of squares based on instructions
	 
    //wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge clk) begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
	 end
	 
	 
	 

    vga640x480 display (
        .i_clk(clk),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(Hsync), 
        .o_vs(Vsync), 
        .o_x(x),
        .o_y(y),
        .o_animate(animate)
    );
	 
	 wire [1:0] state_a1, state_a2, state_a3, state_a4, state_a5, state_a6;
	 wire [1:0] state_b1, state_b2, state_b3, state_b4, state_b5, state_b6;
	 wire [1:0] state_c1, state_c2, state_c3, state_c4, state_c5, state_c6;
	 wire [1:0] state_d1, state_d2, state_d3, state_d4, state_d5, state_d6;

	 

    wire sq_a1, sq_a2, sq_a3, sq_a4, sq_a5, sq_a6;
	 wire sq_b1, sq_b2, sq_b3, sq_b4, sq_b5, sq_b6;
	 wire sq_c1, sq_c2, sq_c3, sq_c4, sq_c5, sq_c6;
	 wire sq_d1, sq_d2, sq_d3, sq_d4, sq_d5, sq_d6;
	 
	 wire line1, line2;
	 
    wire [11:0] sq_a1_x1, sq_a1_x2, sq_a1_y1, sq_a1_y2;  // 12-bit values: 0-4095 
	 wire [11:0] sq_a2_x1, sq_a2_x2, sq_a2_y1, sq_a2_y2;
	 wire [11:0] sq_a3_x1, sq_a3_x2, sq_a3_y1, sq_a3_y2;
	 wire [11:0] sq_a4_x1, sq_a4_x2, sq_a4_y1, sq_a4_y2;
	 wire [11:0] sq_a5_x1, sq_a5_x2, sq_a5_y1, sq_a5_y2;
	 wire [11:0] sq_a6_x1, sq_a6_x2, sq_a6_y1, sq_a6_y2;
	 
    wire [11:0] sq_b1_x1, sq_b1_x2, sq_b1_y1, sq_b1_y2;
	 wire [11:0] sq_b2_x1, sq_b2_x2, sq_b2_y1, sq_b2_y2;
	 wire [11:0] sq_b3_x1, sq_b3_x2, sq_b3_y1, sq_b3_y2;
	 wire [11:0] sq_b4_x1, sq_b4_x2, sq_b4_y1, sq_b4_y2;
	 wire [11:0] sq_b5_x1, sq_b5_x2, sq_b5_y1, sq_b5_y2;
	 wire [11:0] sq_b6_x1, sq_b6_x2, sq_b6_y1, sq_b6_y2;
	 
    wire [11:0] sq_c1_x1, sq_c1_x2, sq_c1_y1, sq_c1_y2;
	 wire [11:0] sq_c2_x1, sq_c2_x2, sq_c2_y1, sq_c2_y2;
	 wire [11:0] sq_c3_x1, sq_c3_x2, sq_c3_y1, sq_c3_y2;
	 wire [11:0] sq_c4_x1, sq_c4_x2, sq_c4_y1, sq_c4_y2;
	 wire [11:0] sq_c5_x1, sq_c5_x2, sq_c5_y1, sq_c5_y2;
	 wire [11:0] sq_c6_x1, sq_c6_x2, sq_c6_y1, sq_c6_y2;

	 wire [11:0] sq_d1_x1, sq_d1_x2, sq_d1_y1, sq_d1_y2;
	 wire [11:0] sq_d2_x1, sq_d2_x2, sq_d2_y1, sq_d2_y2;
	 wire [11:0] sq_d3_x1, sq_d3_x2, sq_d3_y1, sq_d3_y2;
	 wire [11:0] sq_d4_x1, sq_d4_x2, sq_d4_y1, sq_d4_y2;
	 wire [11:0] sq_d5_x1, sq_d5_x2, sq_d5_y1, sq_d5_y2;
	 wire [11:0] sq_d6_x1, sq_d6_x2, sq_d6_y1, sq_d6_y2;

    square sq_a1_anim (
        .i_clk(clk), 
		  .enable(enable[23]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a1_x1),
        .o_x2(sq_a1_x2),
        .o_y1(sq_a1_y1),
        .o_y2(sq_a1_y2),
		  .state(state_a1)
		  );
	 square sq_a2_anim (
        .i_clk(clk), 
		  .enable(enable[22]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a2_x1),
        .o_x2(sq_a2_x2),
        .o_y1(sq_a2_y1),
        .o_y2(sq_a2_y2),
		  .state(state_a2)
    );
	 square sq_a3_anim (
        .i_clk(clk), 
		  .enable(enable[21]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a3_x1),
        .o_x2(sq_a3_x2),
        .o_y1(sq_a3_y1),
        .o_y2(sq_a3_y2),
		  .state(state_a3)
    );
	 square sq_a4_anim (
        .i_clk(clk), 
		  .enable(enable[20]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a4_x1),
        .o_x2(sq_a4_x2),
        .o_y1(sq_a4_y1),
        .o_y2(sq_a4_y2),
		  .state(state_a4)
    );
	 square sq_a5_anim (
        .i_clk(clk), 
		  .enable(enable[19]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a5_x1),
        .o_x2(sq_a5_x2),
        .o_y1(sq_a5_y1),
        .o_y2(sq_a5_y2),
		  .state(state_a5)
    );
	 square sq_a6_anim (
        .i_clk(clk), 
		  .enable(enable[18]),
		  .column(4'b1000),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a6_x1),
        .o_x2(sq_a6_x2),
        .o_y1(sq_a6_y1),
        .o_y2(sq_a6_y2),
		  .state(state_a6)
    );
	 

    square sq_b1_anim (
        .i_clk(clk), 
		  .enable(enable[17]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b1_x1),
        .o_x2(sq_b1_x2),
        .o_y1(sq_b1_y1),
        .o_y2(sq_b1_y2),
		  .state(state_b1)
    );
	 square sq_b2_anim (
        .i_clk(clk), 
		  .enable(enable[16]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b2_x1),
        .o_x2(sq_b2_x2),
        .o_y1(sq_b2_y1),
        .o_y2(sq_b2_y2),
		  .state(state_b2)
    ); 
	 square sq_b3_anim (
        .i_clk(clk), 
		  .enable(enable[15]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b3_x1),
        .o_x2(sq_b3_x2),
        .o_y1(sq_b3_y1),
        .o_y2(sq_b3_y2),
		  .state(state_b3)
    ); 
	 square sq_b4_anim (
        .i_clk(clk), 
		  .enable(enable[14]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b4_x1),
        .o_x2(sq_b4_x2),
        .o_y1(sq_b4_y1),
        .o_y2(sq_b4_y2),
		  .state(state_b4)
    ); 
	 square sq_b5_anim (
        .i_clk(clk), 
		  .enable(enable[13]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b5_x1),
        .o_x2(sq_b5_x2),
        .o_y1(sq_b5_y1),
        .o_y2(sq_b5_y2),
		  .state(state_b5)
    ); 
	 square sq_b6_anim (
        .i_clk(clk), 
		  .enable(enable[12]),
		  .column(4'b0100),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b6_x1),
        .o_x2(sq_b6_x2),
        .o_y1(sq_b6_y1),
        .o_y2(sq_b6_y2),
		  .state(state_b6)
    ); 

    square sq_c1_anim (
        .i_clk(clk),
		  .enable(enable[11]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c1_x1),
        .o_x2(sq_c1_x2),
        .o_y1(sq_c1_y1),
        .o_y2(sq_c1_y2),
		  .state(state_c1)
    );
	 square sq_c2_anim (
        .i_clk(clk),
		  .enable(enable[10]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c2_x1),
        .o_x2(sq_c2_x2),
        .o_y1(sq_c2_y1),
        .o_y2(sq_c2_y2),
		  .state(state_c2)
    );
	 square sq_c3_anim (
        .i_clk(clk),
		  .enable(enable[9]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c3_x1),
        .o_x2(sq_c3_x2),
        .o_y1(sq_c3_y1),
        .o_y2(sq_c3_y2),
		  .state(state_c3)
    );
	 square sq_c4_anim (
        .i_clk(clk),
		  .enable(enable[8]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c4_x1),
        .o_x2(sq_c4_x2),
        .o_y1(sq_c4_y1),
        .o_y2(sq_c4_y2),
		  .state(state_c4)
    );
	 square sq_c5_anim (
        .i_clk(clk),
		  .enable(enable[7]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c5_x1),
        .o_x2(sq_c5_x2),
        .o_y1(sq_c5_y1),
        .o_y2(sq_c5_y2),
		  .state(state_c5)
    );
	 square sq_c6_anim (
        .i_clk(clk),
		  .enable(enable[6]),
		  .column(4'b0010),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c6_x1),
        .o_x2(sq_c6_x2),
        .o_y1(sq_c6_y1),
        .o_y2(sq_c6_y2),
		  .state(state_c6)
    );
	 
	 
	 square sq_d1_anim (
        .i_clk(clk),
		  .enable(enable[5]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d1_x1),
        .o_x2(sq_d1_x2),
        .o_y1(sq_d1_y1),
        .o_y2(sq_d1_y2),
		  .state(state_d1)
    );
	 square sq_d2_anim (
        .i_clk(clk),
		  .enable(enable[4]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d2_x1),
        .o_x2(sq_d2_x2),
        .o_y1(sq_d2_y1),
        .o_y2(sq_d2_y2),
		  .state(state_d2)
    );
	 square sq_d3_anim (
        .i_clk(clk),
		  .enable(enable[3]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d3_x1),
        .o_x2(sq_d3_x2),
        .o_y1(sq_d3_y1),
        .o_y2(sq_d3_y2),
		  .state(state_d3)
    );
	 square sq_d4_anim (
        .i_clk(clk),
		  .enable(enable[2]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d4_x1),
        .o_x2(sq_d4_x2),
        .o_y1(sq_d4_y1),
        .o_y2(sq_d4_y2),
		  .state(state_d4)
    );
	 square sq_d5_anim (
        .i_clk(clk),
		  .enable(enable[1]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d5_x1),
        .o_x2(sq_d5_x2),
        .o_y1(sq_d5_y1),
        .o_y2(sq_d5_y2),
		  .state(state_d5)
    );
	 square sq_d6_anim (
        .i_clk(clk),
		  .enable(enable[0]),
		  .column(4'b0001),
		  .speed(speed),
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_d6_x1),
        .o_x2(sq_d6_x2),
        .o_y1(sq_d6_y1),
        .o_y2(sq_d6_y2),
		  .state(state_d6)
    );
	 

    assign sq_a1 = ((x > sq_a1_x1) & (y > sq_a1_y1) &
        (x < sq_a1_x2) & (y < sq_a1_y2)) ? 1 : 0;
    assign sq_a2 = ((x > sq_a2_x1) & (y > sq_a2_y1) &
        (x < sq_a2_x2) & (y < sq_a2_y2)) ? 1 : 0;
    assign sq_a3 = ((x > sq_a3_x1) & (y > sq_a3_y1) &
        (x < sq_a3_x2) & (y < sq_a3_y2)) ? 1 : 0;
    assign sq_a4 = ((x > sq_a4_x1) & (y > sq_a4_y1) &
        (x < sq_a4_x2) & (y < sq_a4_y2)) ? 1 : 0;
    assign sq_a5 = ((x > sq_a5_x1) & (y > sq_a5_y1) &
        (x < sq_a5_x2) & (y < sq_a5_y2)) ? 1 : 0;
    assign sq_a6 = ((x > sq_a6_x1) & (y > sq_a6_y1) &
        (x < sq_a6_x2) & (y < sq_a6_y2)) ? 1 : 0;
		  
    assign sq_b1 = ((x > sq_b1_x1) & (y > sq_b1_y1) &
        (x < sq_b1_x2) & (y < sq_b1_y2)) ? 1 : 0;
	 assign sq_b2 = ((x > sq_b2_x1) & (y > sq_b2_y1) &
        (x < sq_b2_x2) & (y < sq_b2_y2)) ? 1 : 0;
	 assign sq_b3 = ((x > sq_b3_x1) & (y > sq_b3_y1) &
        (x < sq_b3_x2) & (y < sq_b3_y2)) ? 1 : 0;
	 assign sq_b4 = ((x > sq_b4_x1) & (y > sq_b4_y1) &
        (x < sq_b4_x2) & (y < sq_b4_y2)) ? 1 : 0;
	 assign sq_b5 = ((x > sq_b5_x1) & (y > sq_b5_y1) &
        (x < sq_b5_x2) & (y < sq_b5_y2)) ? 1 : 0;
	 assign sq_b6 = ((x > sq_b6_x1) & (y > sq_b6_y1) &
        (x < sq_b6_x2) & (y < sq_b6_y2)) ? 1 : 0;
		  
    assign sq_c1 = ((x > sq_c1_x1) & (y > sq_c1_y1) &
        (x < sq_c1_x2) & (y < sq_c1_y2)) ? 1 : 0;
	 assign sq_c2 = ((x > sq_c2_x1) & (y > sq_c2_y1) &
        (x < sq_c2_x2) & (y < sq_c2_y2)) ? 1 : 0;
	 assign sq_c3 = ((x > sq_c3_x1) & (y > sq_c3_y1) &
        (x < sq_c3_x2) & (y < sq_c3_y2)) ? 1 : 0;
	 assign sq_c4 = ((x > sq_c4_x1) & (y > sq_c4_y1) &
        (x < sq_c4_x2) & (y < sq_c4_y2)) ? 1 : 0;
	 assign sq_c5 = ((x > sq_c5_x1) & (y > sq_c5_y1) &
        (x < sq_c5_x2) & (y < sq_c5_y2)) ? 1 : 0;
	 assign sq_c6 = ((x > sq_c6_x1) & (y > sq_c6_y1) &
        (x < sq_c6_x2) & (y < sq_c6_y2)) ? 1 : 0;

	 assign sq_d1 = ((x > sq_d1_x1) & (y > sq_d1_y1) &
        (x < sq_d1_x2) & (y < sq_d1_y2)) ? 1 : 0;
	 assign sq_d2 = ((x > sq_d2_x1) & (y > sq_d2_y1) &
        (x < sq_d2_x2) & (y < sq_d2_y2)) ? 1 : 0;
	 assign sq_d3 = ((x > sq_d3_x1) & (y > sq_d3_y1) &
        (x < sq_d3_x2) & (y < sq_d3_y2)) ? 1 : 0;
	 assign sq_d4 = ((x > sq_d4_x1) & (y > sq_d4_y1) &
        (x < sq_d4_x2) & (y < sq_d4_y2)) ? 1 : 0;
	 assign sq_d5 = ((x > sq_d5_x1) & (y > sq_d5_y1) &
        (x < sq_d5_x2) & (y < sq_d5_y2)) ? 1 : 0;
	 assign sq_d6 = ((x > sq_d6_x1) & (y > sq_d6_y1) &
        (x < sq_d6_x2) & (y < sq_d6_y2)) ? 1 : 0;

		  
	 assign line1 = (y > 463) & (y < 467) ? 1 : 0;
	 assign line2 = (y > 413) & (y < 417) ? 1 : 0;

    assign vgaRed[2] = (sq_a1 | sq_a2 | sq_a3 | sq_a4 | sq_a5| sq_a6 |
								sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 | //squares in d are yellow, red + green
								line1 | line2) ? 1 : 0;  // squares in a column are red
								
	 assign vgaRed[1] = (sq_a1 | sq_a2 | sq_a3 | sq_a4 | sq_a5| sq_a6 |
								sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 |
								line1 | line2 ) ? 1 : 0;
								
	 assign vgaRed[0] = (sq_a1 | sq_a2 | sq_a3 | sq_a4 | sq_a5| sq_a6 |
								sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 |
								line1 | line2 ) ? 1 : 0;
								
								
    assign vgaGreen[2] = (~alive | sq_b1 | sq_b2 | sq_b3 | sq_b4 | sq_b5 | sq_b6 |  //squares in column b are green, 
								  sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 |
								  line1 | line2) ? 1 : 0;
	 assign vgaGreen[1] = (~alive | sq_b1 | sq_b2 | sq_b3 | sq_b4 | sq_b5 | sq_b6 |
								  sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 |
								  line1 | line2) ? 1 : 0;
	 assign vgaGreen[0] = (~alive | sq_b1 | sq_b2 | sq_b3 | sq_b4 | sq_b5 | sq_b6 |
								  sq_d1 | sq_d2 | sq_d3 | sq_d4 | sq_d5 | sq_d6 |
								  line1 | line2) ? 1 : 0;
								  
    assign vgaBlue[2] = (~alive | sq_c1 | sq_c2 | sq_c3 | sq_c4 | sq_c5 | sq_c6 |
								line1 | line2) ? 1 : 0;  // square c is blue
	 assign vgaBlue[1] = (~alive | sq_c1 | sq_c2 | sq_c3 | sq_c4 | sq_c5 | sq_c6 |
								line1 | line2) ? 1 : 0;
	 
	 
endmodule
