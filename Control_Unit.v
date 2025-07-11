module Control_Unit(
input [5:0] OpCode,
input [5:0] Func,
output reg [3:0] AluOp,
output reg RegDst, MemtoReg, AluSrc, RegWrite, Memread, Memwrite, Branch, Jmp, JR, JAL
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
   JR_Func  = 6'b001000,  // Jump Register Function
	SLL_Func = 6'b000000,	// SLL Function
	SRL_Func = 6'b000010;	// SRL Function
	
parameter  
	RTYPE_OpCode = 6'b000000,  // OpCode for R-type instructions
	XORI_OpCode  = 6'b001110,  // OpCode for XOR immediate instruction
	ADDI_OpCode  = 6'b001000,  // OpCode for ADD immediate instruction	
	ORI_OpCode   = 6'b001101,  // OpCode for OR immediate instruction
	BEQ_OpCode   = 6'b000100,  // OpCode for Branch on Equal instruction
	BNE_OpCode 	 = 6'b000101,  // OpCode for BNE instruction
	JAL_OpCode   = 6'b000011,  // OpCode for Jump and Link instruction
	LW_OpCode    = 6'b100011,  // OpCode for Load Word instruction
	SW_OpCode    = 6'b101011,  // OpCode for Store Word instruction
	ANDI_OpCode  = 6'b001100,  // OpCode for AND immediate instruction
	J_OpCode	 	 = 6'b000010,  // OpCode for Jump instruction
	SLTI_OpCode  = 6'b001010;  // OpCode for Set Less Than immediate instruction



always @ (*) begin 

	case(OpCode)
		RTYPE_OpCode:		begin
			// Default values for a R-type instruction 
			AluOp        = 4'b1111;		// NOP
			RegDst       = 1'b1;
			MemtoReg     = 1'b0;
			AluSrc       = 1'b0;
			RegWrite     = 1'b0;		// For safety purposes, we turned off RegWrite signal.
			Memread      = 1'b0;
			Memwrite     = 1'b0;
			Branch       = 1'b0;
			Jmp          = 1'b0;
			JR	          = 1'b0;		// X
			JAL		    = 1'b0;
			case(Func)
			
				ADD_Func: 	begin 
					AluOp    = 4'b0000;
					RegWrite = 1'b1;				
							end
							
							
				SUB_Func: 	begin 
					AluOp    = 4'b0001;
					RegWrite = 1'b1;
							end
							
							
				AND_Func: 	begin 
					AluOp    = 4'b0010;
					RegWrite = 1'b1;				
							end
							
							
				OR_Func: 	begin 
					AluOp    = 4'b0011;
					RegWrite = 1'b1;				
							end
							
							
				NOR_Func: 	begin 
					AluOp    = 4'b0100;
					RegWrite = 1'b1;				
							end
							
							
				XOR_Func: 	begin 
					AluOp    = 4'b0101;
					RegWrite = 1'b1;				
							end
							
							
				SLT_Func: 	begin 
					AluOp    = 4'b0110;
					RegWrite = 1'b1;				
							end
							
				SGT_Func: 	begin
					AluOp    = 4'b0111;
					RegWrite = 1'b1;				
							end			
							
				JR_Func: 	begin 
					Jmp      = 1'b1;
					JR    	= 1'b1;
							end
							
				SLL_Func: 	begin
					AluOp    = 4'b1000;
					RegWrite = 1'b1;				
							end
							
				SRL_Func: 	begin
					AluOp    = 4'b1001;
					RegWrite = 1'b1;				
							end
			
				default:;
			endcase 
		end
		
		XORI_OpCode:	begin 
			AluOp        = 4'b0101;
			RegDst       = 1'b0;
			MemtoReg     = 1'b0;
			AluSrc       = 1'b1;
			RegWrite     = 1'b1;
			Memread      = 1'b0;
			Memwrite     = 1'b0;
		   Branch       = 1'b0;
			Jmp          = 1'b0;
			JR	          = 1'b0;
			JAL		    = 1'b0;
						end
						
		ADDI_OpCode: 	begin 
			AluOp    = 4'b0000;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b1;
			RegWrite = 1'b1;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
	
		ORI_OpCode: 	begin 
			AluOp    = 4'b0011;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b1;
			RegWrite = 1'b1;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
	
		BEQ_OpCode: 	begin 
			AluOp    = 4'b1010;
			RegDst   = 1'b0;	// X
			MemtoReg = 1'b0;	// X
			AluSrc   = 1'b0;
			RegWrite = 1'b0;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b1;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end

		BNE_OpCode:		begin
			AluOp    = 4'b1011;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b0;
			RegWrite = 1'b0;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b1;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
						
		JAL_OpCode:		begin 
			AluOp    = 4'b1111;
			RegDst   = 1'b0;	// X
			MemtoReg = 1'b0;	// X
			AluSrc   = 1'b0;	// X
			RegWrite = 1'b1;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b1;
			JR	     = 1'b0;
			JAL		 = 1'b1;
						end
						
		LW_OpCode: 		begin 
			AluOp    = 4'b0000;
			RegDst   = 1'b0;
			MemtoReg = 1'b1;
			AluSrc   = 1'b1;
			RegWrite = 1'b1;
			Memread  = 1'b1;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
						
		SW_OpCode: 		begin 
			AluOp    = 4'b0000;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b1;
			RegWrite = 1'b0;
			Memread  = 1'b0;
			Memwrite = 1'b1;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
						
		ANDI_OpCode:	begin
			AluOp    = 4'b0010;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b1;
			RegWrite = 1'b1;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
						
		J_OpCode:		begin
			AluOp    = 4'b1111;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b0;
			RegWrite = 1'b0;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;	
			Jmp      = 1'b1;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end		

		SLTI_OpCode: 	begin
			AluOp    = 4'b0110;
			RegDst   = 1'b0;
			MemtoReg = 1'b0;
			AluSrc   = 1'b1;
			RegWrite = 1'b1;
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;	
			Jmp      = 1'b0;
			JR	     = 1'b0;
			JAL		 = 1'b0;
						end
						
		default: 		begin 
			AluOp    = 4'b1111;		// NOP
			RegDst   = 1'b1;
			MemtoReg = 1'b0;
			AluSrc   = 1'b0;
			RegWrite = 1'b0;		// For safety purposes, we turned off RegWrite signal.
			Memread  = 1'b0;
			Memwrite = 1'b0;
			Branch   = 1'b0;
			Jmp      = 1'b0;
			JR	     = 1'b0;		// X
			JAL		 = 1'b0;
					
						end 
	endcase
end 
endmodule 











