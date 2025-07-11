module ID_EX_Pipe (

    
    input wire clk,
    input wire Reset,
    input wire [31:0] ID_PC,
    input wire [31:0] readData1,
    input wire [31:0] readData2,
    input wire [31:0] imm_ext,  W0_PC_ID,
    input wire [31:0] ID_inst, branch_target_ID, updated_pc_ID, 
	 input wire [3:0] AluOp_out,
	 input wire JR, oldest_ID,
	 input wire Flush, ID_prediction,
    input wire RegDst_out,
    AluSrc_out, RegWrite_out,Memread_out, Memwrite_out,
	 Branch_out,Jmp_out,JAL_out,
	 input [2:0] ForwardA, ForwardB,	 
	 input [4:0] GHPT_index_ID, GHR_ID, WriteReg_ID,
	 input [4:0] G_BTB_index_ID,
	 input hazard_detected, MemtoReg_ID_out,
	 //input falseNotTaken, falseTaken,
	
	 output reg [3:0] AluOp_EX,
    output reg [31:0] EX_PC,
    output reg [31:0] readData1_out, updated_pc_EX,
    output reg [31:0] readData2_out, W0_PC_EX,
    output reg [31:0] imm_ext_out, branch_target_EX,
	 output reg RegDst_EX,
    AluSrc_EX, RegWrite_EX,Memread_EX, Memwrite_EX,
	 Branch_EX,Jmp_EX,JAL_EX, oldest_EX,
	 output reg JR_EX, EX_prediction,
	 output reg [2:0] ForwardA_EX, ForwardB_EX,
    output reg [31:0] EX_inst,
	 output reg [4:0] GHPT_index_EX, GHR_EX,
	 output reg [4:0] G_BTB_index_EX, WriteReg_EX,
	 output reg hazard_detected_EX, MemtoReg_EX
);


    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
                        EX_PC <= 32'b0;
            readData1_out <= 32'b0;
            readData2_out <= 32'b0;
            imm_ext_out <= 32'b0;
            EX_inst <= 32'b0;
            AluOp_EX <= 1'b0;
				RegDst_EX <= 1'b0;
				AluSrc_EX <= 1'b0;
				RegWrite_EX <= 1'b0;
				Memread_EX <= 1'b0;
				Memwrite_EX <= 1'b0;
				Branch_EX <= 1'b0;
				Jmp_EX <= 1'b0;
				JAL_EX <= 1'b0;
				JR_EX <= 1'b0;
				ForwardA_EX <= 3'b0;
				ForwardB_EX <= 3'b0;
				branch_target_EX <= 32'b0;
				EX_prediction <= 1'b0;
				GHPT_index_EX <= 1'b0;
				GHR_EX <= 1'b0;
				G_BTB_index_EX <= 1'b0;
				updated_pc_EX <= 32'b0;
				WriteReg_EX <= 5'b0;
				hazard_detected_EX <= 1'b0;
				MemtoReg_EX <= 1'b0;
				oldest_EX <= 1'b0;
				W0_PC_EX <= 1'b0;
	 
			end else if (Flush ) begin //&& !JR_Hazard
			 EX_PC <= 32'b0;
            readData1_out <= 32'b0;
            readData2_out <= 32'b0;
            imm_ext_out <= 32'b0;
            EX_inst <= 32'b0;
            AluOp_EX <= 1'b0;
				RegDst_EX <= 1'b0;
				AluSrc_EX <= 1'b0;
				RegWrite_EX <= 1'b0;
				Memread_EX <= 1'b0;
				Memwrite_EX <= 1'b0;
				Branch_EX <= 1'b0;
				Jmp_EX <= 1'b0;
				JAL_EX <= 1'b0;
				ForwardA_EX <= 3'b0;
				ForwardB_EX <= 3'b0;
				branch_target_EX <= 32'b0;
				EX_prediction <= 1'b0;
				GHPT_index_EX <= 'b0;
				GHR_EX <=1'b0;
				G_BTB_index_EX <= 'b0;
				updated_pc_EX <= 32'b0;
				JR_EX <= 1'b0; //else
				WriteReg_EX <= 5'b0;
				hazard_detected_EX <= 1'b0;
				MemtoReg_EX <= 1'b0;
				oldest_EX <= 1'b0;
				W0_PC_EX <= 1'b0;
	 
        end else begin
            EX_PC <= ID_PC;
            readData1_out <= readData1;
            readData2_out <= readData2;
            imm_ext_out <= imm_ext;
            EX_inst <= ID_inst;
            AluOp_EX <= AluOp_out;
				RegDst_EX <= RegDst_out;
				AluSrc_EX <= AluSrc_out;
				RegWrite_EX <= RegWrite_out;
				Memread_EX <= Memread_out;
				Memwrite_EX <= Memwrite_out;
				Branch_EX <= Branch_out;
				Jmp_EX <= Jmp_out;
				JAL_EX <= JAL_out;
				ForwardA_EX <= ForwardA;
				ForwardB_EX <= ForwardB;
				branch_target_EX <= branch_target_ID;
				EX_prediction <= ID_prediction;
				GHPT_index_EX <= GHPT_index_ID;
				GHR_EX <= GHR_ID;
				G_BTB_index_EX <= G_BTB_index_ID;
				updated_pc_EX <= updated_pc_ID;
				JR_EX <= JR;
				WriteReg_EX <= WriteReg_ID;
				hazard_detected_EX <= hazard_detected;
				MemtoReg_EX <= MemtoReg_ID_out;
				oldest_EX <= oldest_ID;
				W0_PC_EX <=  W0_PC_ID;

        end
    end
endmodule