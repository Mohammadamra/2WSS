module Gshare(
	input clk,
	input Reset,
	input [31:0] PC,
	input [31:0] nextPC,
	input [31:0] branch_target, branch_target_EX,
	input Branch, // checks if the instruction is a branch
	input branchTaken, // the actual branch
	input [4:0] GHPT_index_in, GHR_in, BTB_index_in,
	input Branch_EX,
	output reg prediction,
	output reg [31:0] predicted_address,
	output reg [4:0] GHR,
	output [4:0] GHPT_index,
	output [4:0] BTB_index
);

parameter PC_LSB = 5;
parameter table_size = 32;
parameter BTB_size = 32;

parameter [1:0] 
  strongly_not_taken = 2'b00, 
  weakly_not_taken = 2'b01,
  weakly_taken = 2'b10,
  strongly_taken = 2'b11;
  
reg [1:0] GHPT [table_size-1:0];					
reg [59:0] BTB [BTB_size-1:0]; // 1 + 27 + 32

//wire [6:0] GHPT_index; 
//wire [4:0] BTB_index; // 2^6 = 64
wire [26:0] tag; // PC bits other than the BTB_index
wire [26:0] stored_tag;
wire valid, hit;

//reg temp_prediction; // assigning the prediction to the output created some issues

								
assign GHPT_index = PC[PC_LSB-1:0] ^ GHR; 
assign BTB_index = GHPT_index[4:0];

assign tag = PC[26:0]; // 32 - 5 = 27 [31:5]
assign stored_tag = BTB[BTB_index][58:32];
assign valid = BTB[BTB_index][59];
assign hit = (valid && (tag == stored_tag));

always @(negedge clk, posedge Reset) begin: predict
  integer i;
	if (Reset) begin
		for (i = 0; i < table_size; i = i + 1) begin
			GHPT[i] <= weakly_not_taken;
		end
		
		for (i = 0; i < BTB_size; i = i + 1) begin
			BTB[i] <= 0;
		end
		
    //GHR <= 0;
    prediction <= 0;
    predicted_address <= 0;
	end
  
else begin
 /*prediction = 0;
predicted_address = nextPC;*/
		if (Branch_EX) begin
			case (GHPT[GHPT_index_in])
				strongly_not_taken: begin
				
					if (branchTaken)begin
						GHPT[GHPT_index_in] <= weakly_not_taken;
					end
				
					else begin
						GHPT[GHPT_index_in] <= strongly_not_taken;
					end
				end
				
				weakly_not_taken: begin
					
					if (branchTaken)begin
						GHPT[GHPT_index_in] <= weakly_taken;
					end
					
					else begin
						GHPT[GHPT_index_in] <= strongly_not_taken;
					end	
				end
					
				weakly_taken: begin
					
					if (branchTaken)begin
						GHPT[GHPT_index_in] <= strongly_taken;
					end
					
					else begin 
						GHPT[GHPT_index_in] <= weakly_not_taken;
					end
					
				end
				
				strongly_taken: begin
					
					if (branchTaken)begin 
						GHPT[GHPT_index_in] <= strongly_taken;
					end
					
					else begin
						GHPT[GHPT_index_in] <= weakly_taken;
					end	
				end
				
				default: begin
					GHPT[GHPT_index_in] <= strongly_not_taken; 	
				end
			endcase



			if (branchTaken) begin
				BTB[BTB_index_in] <= {1'b1, tag, branch_target_EX}; 
			end 
			
			else begin
				BTB[BTB_index_in] <= {1'b1, tag, nextPC};
			end
		end 
//------------------------------------------------------------			 
		if (Branch) begin	 
			 prediction = (GHPT[GHPT_index][1] == 1);
			 				if(prediction) begin
					if( hit)
						predicted_address <= BTB[BTB_index][31:0];
					else 
						predicted_address <= branch_target;
				end
				else
					    //prediction <= 0;
					predicted_address <= nextPC;
		end
	end
end


always@(posedge clk, posedge Reset) begin // used a separate block to update GHR at negedge
	if(Reset) begin								// because the update should apply for the next branch
		GHR <= 5'b0;									// and not the current branch. Also the reset should be applied 
	end												// in this block to prevent multiple drivers error
	
	else begin
		if(Branch_EX) begin
			if(branchTaken)begin
				GHR <= {GHR_in[3:0], 1'b1};
			end
			
			else begin
				GHR <= GHR_in << 1;
			end 
		end
	end
end

endmodule


/*
		current state			actual prediction			next state
		
	strongly_not_taken				taken					weakly_not_taken
	strongly_not_taken				not taken				strongly_not_taken
	
	weakly_not_taken				taken					weakly_taken
	weakly_not_taken				not taken				strongly_not_taken
	
	weakly_taken					taken					strongly_taken
	weakly_taken					not taken				weakly_not_taken
	
	strongly_taken					taken					strongly_taken
	strongly_taken					not taken				weakly_taken
*/
