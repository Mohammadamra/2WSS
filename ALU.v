module ALU #(parameter size = 32)(
input Reset,
input [3:0] AluOp_EX,
input [size-1:0] ALU_A,
input [size-1:0] ALU_B,
//input [4:0] Shamt,	// Extra input to the ALU
output reg [size-1:0] aluResult
//output wire Zero
);

always@(*) begin
	if(Reset) begin
		aluResult = 0;
	end
	
	else begin
		case(AluOp_EX)

			4'b0111: aluResult = (ALU_A - ALU_B) > 0; // SGT --($signed(ALU_A) > $signed(ALU_B)) ? 1'b1 : 1'b0

			4'b0000: aluResult = $signed(ALU_A) + $signed(ALU_B); // ADD -- 
			
			4'b0001: aluResult = $signed(ALU_A) - $signed(ALU_B); // SUB --
			
			4'b0010: aluResult = ALU_A & ALU_B; // AND --
			
			4'b0011: aluResult = ALU_A | ALU_B; // OR --
			
			4'b0110: aluResult = (ALU_A - ALU_B) < 0; // SLT --
			
			4'b0101: aluResult = ALU_A ^ ALU_B; // XOR --
			
			4'b0100: aluResult = ~(ALU_A | ALU_B); // NOR --
			
			//4'b1000: aluResult = (ALU_B << Shamt); // SLL --	In our Implementation, Refering to the MIPS Green Sheet, 
			
			//4'b1001: aluResult = (ALU_B >> Shamt); // SRL -- 	the Logical shift is done like this 
			
			
			4'b1110: aluResult = ~(ALU_A ^ ALU_B); // XNOR
			
			4'b1101: aluResult = ~(ALU_A & ALU_B); // NAND
			
			//4'b1010: aluResult = (ALU_A == ALU_B) ? 0 : 1; //BEQ
			
			//4'b1011: aluResult = (ALU_A != ALU_B) ? 0 : 1; //BNE
			
			4'b1111: aluResult = 32'hffffffff; //NOP
			
			default: aluResult <= 32'b0;
		endcase

		


	end
end

	//assign Zero = (aluResult == 32'b0) ? 1'b1 : 1'b0; //~|aluResult ;//(aluResult == 32'b0) ? 1'b1 : 1'b0;

endmodule
