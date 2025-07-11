module hazard_detection_unit (
    input wire Memread_EX, Memread_ID, FalseNotTaken, FalseTaken, Way_0_oldest_ID,
	 input [4:0] WriteReg_ID_0, WriteReg_ID_1,
    input wire [31:0] ID_inst_0, ID_inst_1,
    input wire [31:0] EX_inst_0, EX_inst_1, 
	 input JR_EX, Way_0_busy,
    output reg PCWrite,    // Add PCWrite signal
	 output reg Flush_0, Flush_1,		// Handle Flush in HDU
	 output reg hazard_detected_0, hazard_detected_1
    );

    // Internal variables to hold the register fields
    wire [4:0] ID_RegisterRs_0, ID_RegisterRs_1;
    wire [4:0] ID_RegisterRt_0, ID_RegisterRt_1;
    wire [4:0] EX_RegisterRt_0, EX_RegisterRt_1;

    assign ID_RegisterRs_0 = ID_inst_0[25:21];    // rs field
	 assign ID_RegisterRs_1 = ID_inst_1[25:21];    
    assign ID_RegisterRt_0 = ID_inst_0[20:16];    // rt field
	 assign ID_RegisterRt_1 = ID_inst_1[20:16];
    assign EX_RegisterRt_0 = EX_inst_0[20:16];    // rt field in EX stage
	 assign EX_RegisterRt_1 = EX_inst_1[20:16];
	 
		always @(*) begin
			//IF_IDWrite = 1'b1;
			hazard_detected_0 = 1'b0;
			Flush_0 = 1'b0;
			hazard_detected_1 = 1'b0;
			Flush_1 = 1'b0;
			PCWrite = !(hazard_detected_0 || hazard_detected_1);
			
			if(Memread_EX)			// Load Use hazard, when not on the same stage
				if (EX_RegisterRt_0 != 5'b0) begin
					hazard_detected_0 = ((EX_RegisterRt_0 == ID_RegisterRs_0) || (EX_RegisterRt_0 == ID_RegisterRt_0)) ;
					hazard_detected_1 = ((EX_RegisterRt_0 == ID_RegisterRs_1) || (EX_RegisterRt_0 == ID_RegisterRt_1)) ;
					end

			if (Memread_ID)		// Solves LW_use at the same stage
				if (ID_RegisterRt_0 != 5'b0) begin
					hazard_detected_1 = ((ID_RegisterRt_0 == ID_RegisterRs_1) || (ID_RegisterRt_0 == ID_RegisterRt_1)) ;
					end
			
			if (Way_0_oldest_ID && WriteReg_ID_0 !=5'b0 && (( WriteReg_ID_0 == ID_RegisterRs_1) || (ID_RegisterRt_1 == WriteReg_ID_0)) )	// Solves data dependancy at the same stage
				hazard_detected_1 = 1'b1;
			else if ( !Way_0_oldest_ID && WriteReg_ID_1 != 5'b0 && ((WriteReg_ID_1 == ID_RegisterRs_0) || (ID_RegisterRt_0 == WriteReg_ID_1)) )
				hazard_detected_0 = 1'b1;
			
			if( FalseNotTaken || FalseTaken || JR_EX) begin
				Flush_1 = 1'b1; 
				Flush_0 = 1'b1; 
			end
		
	 
		else hazard_detected_1 = Way_0_busy;

	end
	
endmodule

