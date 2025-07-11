module Controller_1(
input [5:0] OpCode_1,
input [5:0] Func_1,
output reg [3:0] AluOp,
output reg RegDst_1, AluSrc_1, RegWrite_1
); 



//define paremeters to add potential instructions to our datapath 

parameter 
	ADD_Func	= 6'b100000,  // ADD Function
	SUB_Func = 6'b100010,  // SUB Function
	AND_Func = 6'b100100,  // AND Function
	OR_Func	= 6'b100101,  // OR Function
	NOR_Func = 6'b100111,  // NOR Function
	XOR_Func = 6'b100110,  // XOR Function
	SLT_Func = 6'b101010,  // Set Less Than Function
	SGT_Func = 6'b110000,	// Custom Function for SGT instruction (not standard)
	SLL_Func = 6'b000000,	// SLL Function
	SRL_Func = 6'b000010;	// SRL Function
	
parameter  
	RTYPE_OpCode = 6'b000000,  // OpCode for R-type instructions
	XORI_OpCode  = 6'b001110,  // OpCode for XOR immediate instruction
	ADDI_OpCode  = 6'b001000,  // OpCode for ADD immediate instruction	
	ORI_OpCode   = 6'b001101,  // OpCode for OR immediate instruction
	ANDI_OpCode  = 6'b001100,  // OpCode for AND immediate instruction
	SLTI_OpCode  = 6'b001010;  // OpCode for Set Less Than immediate instruction



always @ (*) begin 

	case(OpCode_1)
		RTYPE_OpCode:		begin
			// Default values for a R-type instruction 
			AluOp        = 4'b1111;		// NOP
			RegDst_1       = 1'b1;
			AluSrc_1       = 1'b0;
			RegWrite_1     = 1'b0;		// For safety purposes, we turned off RegWrite_1 signal.
			case(Func_1)
			
				ADD_Func: 	begin 
					AluOp    = 4'b0000;
					RegWrite_1 = 1'b1;				
							end
							
							
				SUB_Func: 	begin 
					AluOp    = 4'b0001;
					RegWrite_1 = 1'b1;
							end
							
							
				AND_Func: 	begin 
					AluOp    = 4'b0010;
					RegWrite_1 = 1'b1;				
							end
							
							
				OR_Func: 	begin 
					AluOp    = 4'b0011;
					RegWrite_1 = 1'b1;				
							end
							
							
				NOR_Func: 	begin 
					AluOp    = 4'b0100;
					RegWrite_1 = 1'b1;				
							end
							
							
				XOR_Func: 	begin 
					AluOp    = 4'b0101;
					RegWrite_1 = 1'b1;				
							end
							
							
				SLT_Func: 	begin 
					AluOp    = 4'b0110;
					RegWrite_1 = 1'b1;				
							end
							
				SGT_Func: 	begin
					AluOp    = 4'b0111;
					RegWrite_1 = 1'b1;				
							end			
							
				SLL_Func: 	begin
					AluOp    = 4'b1000;
					RegWrite_1 = 1'b1;				
							end
							
				SRL_Func: 	begin
					AluOp    = 4'b1001;
					RegWrite_1 = 1'b1;				
							end
			
				default:;
			endcase 
		end
		
		XORI_OpCode:	begin 
			AluOp        = 4'b0101;
			RegDst_1       = 1'b0;
			AluSrc_1       = 1'b1;
			RegWrite_1     = 1'b1;
						end
						
		ADDI_OpCode: 	begin 
			AluOp    = 4'b0000;
			RegDst_1   = 1'b0;
			AluSrc_1   = 1'b1;
			RegWrite_1 = 1'b1;
						end
	
		ORI_OpCode: 	begin 
			AluOp    = 4'b0011;
			RegDst_1   = 1'b0;
			AluSrc_1   = 1'b1;
			RegWrite_1 = 1'b1;
						end

		ANDI_OpCode:	begin
			AluOp    = 4'b0010;
			RegDst_1   = 1'b0;
			AluSrc_1   = 1'b1;
			RegWrite_1 = 1'b1;
						end

		SLTI_OpCode: 	begin
			AluOp    = 4'b0110;
			RegDst_1   = 1'b0;
			AluSrc_1   = 1'b1;
			RegWrite_1 = 1'b1;
						end
						
		default: 		begin 
			AluOp    = 4'b1111;		// NOP
			RegDst_1   = 1'b1;
			AluSrc_1   = 1'b0;
			RegWrite_1 = 1'b0;		// For safety purposes, we turned off RegWrite_1 signal.
						end 
	endcase
end 
endmodule 











