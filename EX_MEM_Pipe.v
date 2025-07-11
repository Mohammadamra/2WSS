module EX_MEM_Pipe (
    input wire clk,
    input wire Reset,
	 
    input wire [31:0] EX_inst,
    input wire [31:0] aluResult,
	 input wire [31:0] EX_PC,
	 input [3:0] AluOp_EX,
    input wire Memread_EX, Memwrite_EX, RegWrite_EX, 
    input wire [4:0] WriteReg,
	 input wire Way_0_oldest_EX,
	 input wire RegDst_EX, JAL_EX, MemtoReg_EX,
	 input wire [31:0] shifter_result, ALU_B,


    output reg Memread_MEM, Memwrite_MEM, RegWrite_MEM,
	 output reg [31:0] MEM_inst,
    output reg [31:0] aluResult_out,
	 output reg [31:0] MEM_PC, ALU_B_MEM,
	 output reg [4:0] WriteReg_out, MemtoReg_MEM,
	 output reg RegDst_MEM, JAL_MEM, Way_0_oldest_MEM
);
    always @(posedge clk or posedge Reset) begin
    if (Reset) begin
        
        Memread_MEM <= 1'b0;
        Memwrite_MEM <= 1'b0;
        RegWrite_MEM <= 1'b0;
        MEM_inst <= 32'b0;
        aluResult_out <= 32'b0;
        WriteReg_out <= 5'b0;
		  MEM_PC <= 1'b0;
		  RegDst_MEM <=1'b0;
		  ALU_B_MEM <= 32'b0;
		  JAL_MEM <= 1'b0;
		  MemtoReg_MEM <= 1'b0;
		  Way_0_oldest_MEM <= 1'b0;

		  
    end else begin
       
        Memread_MEM <= Memread_EX;
        Memwrite_MEM <= Memwrite_EX;
        RegWrite_MEM <= RegWrite_EX;
        MEM_inst <= EX_inst;
        WriteReg_out <= WriteReg;
		  MEM_PC <= EX_PC;
		  RegDst_MEM <=RegDst_EX;
		  ALU_B_MEM <= ALU_B;
		  JAL_MEM <= JAL_EX;
		  MemtoReg_MEM <= MemtoReg_EX;
		  aluResult_out <= aluResult;
		  Way_0_oldest_MEM <= Way_0_oldest_EX;
		  /*if (AluOp_EX == 4'b1000 || AluOp_EX == 4'b1001)  // If the operation is Shift --> take the shifter output; else take the aluResult
		  aluResult_out <= shifter_result;
		  else
		  aluResult_out <= aluResult;*/
end

end 
 endmodule


