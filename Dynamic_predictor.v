module Dynamic_predictor(
    input clk,
    input Reset,
    input Branch,
    input [31:0] PC,
    input [31:0] nextPC,
    input [31:0] branch_target, 
    input branchTaken, // Indicates if the branch was actually taken
    output reg prediction,
    output reg [31:0] predicted_address
);

	reg [1:0] state; // Used for prediction
	
    parameter [1:0]
        state0 = 2'b00,
        state1 = 2'b01,
        state2 = 2'b10,
        state3 = 2'b11;
    
    always @(negedge clk or posedge Reset) begin
        if (Reset) begin
				state = state1;
				prediction = 0;
				predicted_address = 0;
        end else if(Branch) begin
            case(state) 
				
				state0: begin
					state = branchTaken ? state1 : state0;
					prediction = 0;
					predicted_address = nextPC;
				end
					
                state1: begin
					state = branchTaken ? state3 : state0;
					prediction = 0;
					predicted_address = nextPC;
				end
				
                state2:begin
					state = branchTaken ? state3 : state0;
					prediction = 1;
					predicted_address = branch_target;
				end
						
                state3: begin
					state = branchTaken ? state3 : state2;
					prediction = 1;
					predicted_address = branch_target;
				end
                default: begin
					state = state1;
					prediction = 0;
					predicted_address = nextPC;
				end
				endcase
				
        end
		  
    end
	 
	 

endmodule
