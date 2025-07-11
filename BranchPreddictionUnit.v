module BranchPreddictionUnitt (
input clk,
input Reset,
input [31:0] PC,
input [31:0] nextPC,
input [31:0] branch_target, branch_target_EX,
input [31:0] jump_target,
input branchTaken,
input [5:0] Opcode,
input Branch_EX,
input [4:0] GHPT_index_in, GHR_in,
input [4:0] G_BTB_index_in,
output prediction,
output reg [31:0] final_address,
output [4:0] GHPT_index,
output [4:0] G_BTB_index,
output [4:0] GHR
);

wire J, Branch;
wire [31:0] predicted_address;

InstructionDecoder IDE (.Opcode(Opcode), .J(J), .Branch(Branch));

Tournament_predictor TP (.clk(clk), .Reset(Reset), .PC(PC), .nextPC(nextPC), .branch_target(branch_target), .Branch(Branch), .branchTaken(branchTaken),
 .prediction(prediction), .predicted_address(predicted_address), .branch_target_EX(branch_target_EX),
 .Branch_EX(Branch_EX),  .GHPT_index_in(GHPT_index_in), .GHR_in(GHR_in), 
 .G_BTB_index_in(G_BTB_index_in), .GHPT_index(GHPT_index), .G_BTB_index(G_BTB_index), .GHR(GHR)
 );

 

always@(*) begin // pay attention to (*) 
	if (J)
		final_address = jump_target;
	else if(Branch)
		final_address = predicted_address;
	else
		final_address = nextPC;
end
	
endmodule 