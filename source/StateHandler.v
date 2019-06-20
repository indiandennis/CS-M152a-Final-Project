`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:24 05/23/2019 
// Design Name: 
// Module Name:    StateHandler 
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
module StateHandler(
	input wire clk,
	input wire rst,
	input wire [3:0] button_press,
	input wire [47:0] square_locations,
	output reg [3:0] column,
	output reg [19:0] sound,
	output reg [23:0] remove,
	output reg [7:0] Led,
	output reg alive,
	output  reg [3:0] score4,
	output  reg [3:0] score3,
	output  reg [3:0] score2,
	output  reg [3:0] score1,
	output reg [7:0] speed
    );
	 
	reg [7:0] song_length;
	
	reg [3:0] 	song_notes 			[49:0];
	reg [3:0] 	song_durations 	[49:0];
	reg [19:0] 	song_sounds 		[49:0];	
	reg [7:0] 	index_notes;
	reg [7:0] 	index_sounds;
	reg [7:0] 	index_durations;
	
	reg [30:0] clk_div_s;	
	reg [19:0] bad_sound;
	
	reg [3:0] lives;
	reg [26:0] clk_1hz;
	
	reg [47:0] prev_square_locations;
	
	
	reg [7:0] i;

		
	always @(posedge clk) begin
		if(rst) begin
			index_notes <= 0;
			index_durations <= 0;
			index_sounds <= 0;
			clk_div_s <= 31'b1;
			clk_1hz  <= 27'b0;
			remove <= 0;
			Led <= 0;
			score4 <= 0;
			score3 <= 0;
			score2 <= 0;
			score1 <= 0;
			alive <= 1;
			lives <= 4'd8;
			prev_square_locations <= 0;
			
			speed <= 8'd2;
			
			// Hardcode song in
			// Demo song
			song_length <= 8'd49;
			
			bad_sound <= 20'd572705;
			
			song_durations[0] <= 4'd4;
			song_durations[1] <= 4'd1;
			song_durations[2] <= 4'd1;
			song_durations[3] <= 4'd1;
			song_durations[4] <= 4'd1;
			song_durations[5] <= 4'd2;
			song_durations[6] <= 4'd2;
			song_durations[7] <= 4'd3;
			song_durations[8] <= 4'd1;
			song_durations[9] <= 4'd1;
			song_durations[10] <= 4'd1;
			song_durations[11] <= 4'd1;
			song_durations[12] <= 4'd2;
			song_durations[13] <= 4'd2;
			song_durations[14] <= 4'd3;
			song_durations[15] <= 4'd1;
			song_durations[16] <= 4'd1;
			song_durations[17] <= 4'd1;
			song_durations[18] <= 4'd1;
			song_durations[19] <= 4'd3;
			song_durations[20] <= 4'd2;
			song_durations[21] <= 4'd3;
			song_durations[22] <= 4'd2;
			song_durations[23] <= 4'd2;
			song_durations[24] <= 4'd4;
			song_durations[25] <= 4'd4;
			song_durations[26] <= 4'd1;
			song_durations[27] <= 4'd1;
			song_durations[28] <= 4'd1;
			song_durations[29] <= 4'd1;
			song_durations[30] <= 4'd2;
			song_durations[31] <= 4'd2;
			song_durations[32] <= 4'd3;
			song_durations[33] <= 4'd1;
			song_durations[34] <= 4'd1;
			song_durations[35] <= 4'd1;
			song_durations[36] <= 4'd1;
			song_durations[37] <= 4'd3;
			song_durations[38] <= 4'd1;
			song_durations[39] <= 4'd3;
			song_durations[40] <= 4'd1;
			song_durations[41] <= 4'd1;
			song_durations[42] <= 4'd1;
			song_durations[43] <= 4'd1;
			song_durations[44] <= 4'd3;
			song_durations[45] <= 4'd2;
			song_durations[46] <= 4'd3;
			song_durations[47] <= 4'd2;
			song_durations[48] <= 4'd2;
			song_durations[49] <= 4'd2;
			


			song_sounds[0] <= 20'd240790; //Ab4
			song_sounds[1] <= 20'd214519; //Bb4
			song_sounds[2] <= 20'd180385; //Db5
			song_sounds[3] <= 20'd214519; //Bb4
			song_sounds[4] <= 20'd143172; //F5
			song_sounds[5] <= 20'd143172; //F5
			song_sounds[11] <= 20'd160707; //Eb5
			song_sounds[7] <= 20'd240790; //Ab4
			song_sounds[8] <= 20'd214519; //Bb4
			song_sounds[9] <= 20'd191113; //C5
			song_sounds[10] <= 20'd240790; //Ab4
			song_sounds[11] <= 20'd160707; //Eb5
			song_sounds[12] <= 20'd160707; //Eb5
			song_sounds[13] <= 20'd180385; //Db5
			song_sounds[14] <= 20'd240790; //Ab4
			song_sounds[15] <= 20'd214519; //Bb4
			song_sounds[16] <= 20'd180385; //Db5
			song_sounds[17] <= 20'd214519; //Bb4
			song_sounds[18] <= 20'd180385; //Db5
			song_sounds[19] <= 20'd160707; //Eb5
			song_sounds[20] <= 20'd191113; //C5
			song_sounds[21] <= 20'd240790; //Ab4
			song_sounds[22] <= 20'd240790; //Ab4
			song_sounds[23] <= 20'd160707; //Eb5
			song_sounds[24] <= 20'd180385; //Db5
			song_sounds[25] <= 20'd240790; //Ab4
			song_sounds[26] <= 20'd214519; //Bb4
			song_sounds[27] <= 20'd180385; //Db5
			song_sounds[28] <= 20'd214519; //Bb4
			song_sounds[29] <= 20'd143172; //F5
			song_sounds[30] <= 20'd143172; //F5
			song_sounds[31] <= 20'd160707; //Eb5
			song_sounds[32] <= 20'd240790; //Ab4
			song_sounds[33] <= 20'd214519; //Bb4
			song_sounds[34] <= 20'd191113; //C5
			song_sounds[35] <= 20'd240790; //Ab4
			song_sounds[36] <= 20'd120393; //Ab5
			song_sounds[37] <= 20'd191113; //C5
			song_sounds[38] <= 20'd180385; //Db5
			song_sounds[39] <= 20'd240790; //Ab4
			song_sounds[40] <= 20'd214519; //Bb4
			song_sounds[41] <= 20'd180385; //Db5
			song_sounds[42] <= 20'd214519; //Bb4
			song_sounds[43] <= 20'd180385; //Db5
			song_sounds[44] <= 20'd160707; //Eb5
			song_sounds[45] <= 20'd191113; //C5
			song_sounds[46] <= 20'd240790; //Ab4
			song_sounds[47] <= 20'd240790; //Ab4
			song_sounds[48] <= 20'd160707; //Eb5
			song_sounds[49] <= 20'd180385; //Db5

			song_notes[0] <= 4'b1000;
			song_notes[1] <= 4'b0100;
			song_notes[2] <= 4'b0010;
			song_notes[3] <= 4'b0100;
			song_notes[4] <= 4'b0001;
			song_notes[5] <= 4'b0001;
			song_notes[6] <= 4'b0010;
			song_notes[7] <= 4'b1000;
			song_notes[8] <= 4'b0100;
			song_notes[9] <= 4'b0010;
			song_notes[10] <= 4'b0100;
			song_notes[11] <= 4'b0001;
			song_notes[12] <= 4'b0001;
			song_notes[13] <= 4'b0010;
			song_notes[14] <= 4'b1000;
			song_notes[15] <= 4'b0100;
			song_notes[16] <= 4'b0010;
			song_notes[17] <= 4'b0100;
			song_notes[18] <= 4'b0010;
			song_notes[19] <= 4'b0001;
			song_notes[20] <= 4'b0100;
			song_notes[21] <= 4'b1000;
			song_notes[22] <= 4'b1000;
			song_notes[23] <= 4'b0001;
			song_notes[24] <= 4'b0010;
			song_notes[25] <= 4'b1000;
			song_notes[26] <= 4'b0100;
			song_notes[27] <= 4'b0010;
			song_notes[28] <= 4'b0100;
			song_notes[29] <= 4'b0001;
			song_notes[30] <= 4'b0001;
			song_notes[31] <= 4'b0010;
			song_notes[32] <= 4'b1000;
			song_notes[33] <= 4'b0100;
			song_notes[34] <= 4'b0010;
			song_notes[35] <= 4'b0100;
			song_notes[36] <= 4'b0001;
			song_notes[37] <= 4'b0100;
			song_notes[38] <= 4'b0010;
			song_notes[39] <= 4'b1000;
			song_notes[40] <= 4'b0100;
			song_notes[41] <= 4'b0010;
			song_notes[42] <= 4'b0100;
			song_notes[43] <= 4'b0010;
			song_notes[44] <= 4'b0001;
			song_notes[45] <= 4'b0100;
			song_notes[46] <= 4'b1000;
			song_notes[47] <= 4'b1000;
			song_notes[48] <= 4'b0001;
			song_notes[49] <= 4'b0010;

			sound <= 0;
		end
		else if(lives > 0) begin
			// Hardcode song in
			// Demo song
			
			// 1s clk, replace with speed up later 
			if(clk_div_s == song_durations[index_durations] * 100000000/speed) begin
				clk_div_s <= 0;
				if(index_durations == song_length) begin
					index_durations <= 0;
					speed <= speed + 1;
				end else
					index_durations <= index_durations + 1;
			end else begin
				clk_div_s <= clk_div_s + 1;
				index_durations <= index_durations;
			end
			
			/*if(clk_div_s == 100000000) begin
				clk_div_s <= 0;
			end
			else
				clk_div_s <= clk_div_s + 1;*/
			
			//SCORE:
			//Add 1 to score every second alive
			if(clk_1hz == 27'd100000000) begin
				clk_1hz <= 0;
				if(score1 == 4'd9) begin
					if(score2 == 4'd9) begin
						if(score3 == 4'd9) begin
							score4 <= score4 + 1;
							score3 <= 0;
						end
						else
							score3 <= score3 + 1;
						score2 <= 0;
					end
					else
						score2 <= score2 + 1;
					score1 <= 0;
				end
				else
					score1 <= score1 + 1;
			end
			else begin
				clk_1hz <= clk_1hz + 1;
				score1 <= score1;
				score2 <= score2;
				score3 <= score3;
				score4 <= score4;
			end
			
			// Button is pressed, play note
			if(button_press != 0) begin
				// handle button presses here
				if(button_press[0]) begin
					// Has square in zone
					if(square_locations[0] || 
						square_locations[2] || 
						square_locations[4] || 
						square_locations[6] || 
						square_locations[8] || 
						square_locations[10]) 
					begin
						sound <= song_sounds[index_sounds];
						lives <= lives;
						for(i = 0; i <= 10; i = i + 2)
							if (square_locations[i])
								remove[i>>1] <= 1;
						if(index_sounds == song_length)
							index_sounds <= 0;
						else
							index_sounds <= index_sounds + 1;
					end else begin
						sound <= bad_sound;
						//lives <= lives - 1;
						index_sounds <= index_sounds;
					end
				end
				
				if(button_press[1]) begin
					// Has square in zone
					if(square_locations[12] || 
						square_locations[14] || 
						square_locations[16] || 
						square_locations[18] || 
						square_locations[20] || 
						square_locations[22]) 
					begin
						sound <= song_sounds[index_sounds];
						lives <= lives;
						for(i = 12; i <= 22; i = i + 2)
							if (square_locations[i])
								remove[i>>1] <= 1;
						if(index_sounds == song_length)
							index_sounds <= 0;
						else
							index_sounds <= index_sounds + 1;
					end else begin
						sound <= bad_sound;
						//lives <= lives - 1;
						index_sounds <= index_sounds;
					end
				end
			
			
				if(button_press[2]) begin
					// Has square in zone
					if(square_locations[24] || 
						square_locations[26] || 
						square_locations[28] || 
						square_locations[30] || 
						square_locations[32] || 
						square_locations[34]) 
					begin
						sound <= song_sounds[index_sounds];
						lives <= lives;
						for(i = 24; i <= 34; i = i + 2)
							if (square_locations[i])
								remove[i>>1] <= 1;
						if(index_sounds == song_length)
							index_sounds <= 0;
						else
							index_sounds <= index_sounds + 1;
					end else begin
						sound <= bad_sound;
						//lives <= lives - 1;
						index_sounds <= index_sounds;
					end
				end
			
				if(button_press[3]) begin
					// Has square in zone
					if(square_locations[36] || 
						square_locations[38] || 
						square_locations[40] || 
						square_locations[42] || 
						square_locations[44] || 
						square_locations[46]) 
					begin
						sound <= song_sounds[index_sounds];
						lives <= lives;
						for(i = 36; i <= 46; i = i + 2)
							if (square_locations[i])
								remove[i>>1] <= 1;
						if(index_sounds == song_length)
							index_sounds <= 0;
						else
							index_sounds <= index_sounds + 1;
					end else begin
						sound <= bad_sound;
						//lives <= lives - 1;
						index_sounds <= index_sounds;
					end
				end
			end else begin
				index_sounds <= index_sounds;
				remove <= 0;
				lives <= lives;
				sound <= 0;
			end
			
			// Note at end zone, deduct life
			for(i = 1; i <= 47; i = i + 2) begin
				if(~square_locations[i] & prev_square_locations[i])
				begin
					lives <= lives - 1;
					sound <= bad_sound;
					if(index_sounds == song_length)
						index_sounds <= 0;
					else
						index_sounds <= index_sounds + 1;
				end
			end
			
			
			// Timer reached, display a new note
			if(clk_div_s == 0) begin			
				if(index_notes == song_length) begin
					index_notes <= 0;
					column <= song_notes[song_length];	
				end
				else begin
					index_notes <= index_notes + 1;
					column <= song_notes[index_notes];
				end
			end else begin
				column <= 0;			
				index_notes <= index_notes;
			end		
		end
		else begin
			alive <= 0;
			sound <= bad_sound;
		end
		
		case (lives)
				4'd0:
					Led <= 8'b0;
				4'd1:
					Led <= 8'b1;
				4'd2:
					Led <= 8'b11;
				4'd3:
					Led <= 8'b111;
				4'd4:
					Led <= 8'b1111;
				4'd5:
					Led <= 8'b11111;
				4'd6:
					Led <= 8'b111111;
				4'd7:
					Led <= 8'b1111111;
				4'd8:
					Led <= 8'b11111111;
				default:
					Led <= 8'b11111110;
		endcase
		
		prev_square_locations <= square_locations;
		
	end

endmodule
